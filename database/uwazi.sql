
-- Table structure for table `agency`

CREATE TABLE `agency` (
  `id` char(36) NOT NULL,
  `location_id` char(36) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `short_name` varchar(50) DEFAULT NULL,
  `agency_type` enum('national_ministry','county_department','parastatal','development_partner','ngo_pmu') NOT NULL,
  `sector` varchar(100) DEFAULT NULL,
  `contact_email` varchar(150) DEFAULT NULL,
  `contact_phone` varchar(20) DEFAULT NULL,
  `website_url` varchar(255) DEFAULT NULL,
  `hod_name` varchar(150) DEFAULT NULL,
  `sla_response_days` int DEFAULT '14',
  `country_code` char(2) DEFAULT 'KE',
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `location_id` (`location_id`),
  CONSTRAINT `agency_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for table `audit_log`

CREATE TABLE `audit_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` char(36) DEFAULT NULL,
  `table_name` varchar(60) NOT NULL,
  `record_id` char(36) NOT NULL,
  `operation` enum('INSERT','UPDATE','DELETE','LOGIN','LOGOUT','EXPORT','API_ACCESS') NOT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `changed_fields` json DEFAULT NULL,
  `performed_by_identity` varchar(150) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `session_id` varchar(150) NOT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `request_id` varchar(100) DEFAULT NULL,
  `hash` char(64) NOT NULL,
  `prev_hash` char(64) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `audit_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for table `budget`

CREATE TABLE `budget` (
  `id` char(36) NOT NULL,
  `project_id` char(36) NOT NULL,
  `fiscal_year` char(9) NOT NULL,
  `budget_phase` enum('original','revised','supplementary') DEFAULT 'original',
  `revision_no` int DEFAULT '1',
  `total_amount` decimal(20,2) NOT NULL,
  `currency` char(3) DEFAULT 'KES',
  `exchange_rate_to_kes` decimal(12,4) DEFAULT '1.0000',
  `approved_by` varchar(150) NOT NULL,
  `approved_date` date NOT NULL,
  `approval_document_url` varchar(500) DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `budget_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for table `budget_line`

CREATE TABLE `budget_line` (
  `id` char(36) NOT NULL,
  `budget_id` char(36) NOT NULL,
  `category` enum('labour','materials','equipment','professional_fees','vat','contingency','land_acquisition','environmental','supervision','admin_overhead','other') NOT NULL,
  `description` varchar(300) NOT NULL,
  `planned_amount` decimal(18,2) NOT NULL,
  `committed_amount` decimal(18,2) DEFAULT '0.00',
  `actual_amount` decimal(18,2) DEFAULT '0.00',
  `variance` decimal(18,2) GENERATED ALWAYS AS ((`planned_amount` - `actual_amount`)) STORED,
  `unit` varchar(50) DEFAULT NULL,
  `unit_quantity` decimal(12,2) DEFAULT NULL,
  `unit_cost` decimal(14,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `budget_id` (`budget_id`),
  CONSTRAINT `budget_line_ibfk_1` FOREIGN KEY (`budget_id`) REFERENCES `budget` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for table `citizen_report`

CREATE TABLE `citizen_report` (
  `id` char(36) NOT NULL,
  `project_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `report_type` enum('progress_update','stalled','substandard_quality','fraud_suspected','abandoned','hazard','completed','request_info') NOT NULL,
  `description` text NOT NULL,
  `completion_estimate_pct` decimal(5,2) DEFAULT NULL,
  `geo_lat` decimal(10,8) NOT NULL,
  `geo_lng` decimal(11,8) NOT NULL,
  `status` enum('pending','validated','disputed','suppressed','escalated_to_complaint') DEFAULT 'pending',
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `citizen_report_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`),
  CONSTRAINT `citizen_report_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for table `complaint`

CREATE TABLE `complaint` (
  `id` char(36) NOT NULL,
  `project_id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `source_report_id` char(36) DEFAULT NULL,
  `assigned_agency_id` char(36) DEFAULT NULL,
  `category` enum('stalled_project','substandard_work','funds_misuse','safety_hazard','contractor_issue','corruption_suspicion','data_inaccuracy','other') NOT NULL,
  `severity` enum('low','medium','high','critical') DEFAULT 'medium',
  `title` varchar(300) NOT NULL,
  `description` text NOT NULL,
  `status` enum('open','under_review','pending_agency','resolved','escalated','closed','rejected') DEFAULT 'open',
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  KEY `user_id` (`user_id`),
  KEY `source_report_id` (`source_report_id`),
  KEY `assigned_agency_id` (`assigned_agency_id`),
  CONSTRAINT `complaint_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`),
  CONSTRAINT `complaint_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `complaint_ibfk_3` FOREIGN KEY (`source_report_id`) REFERENCES `citizen_report` (`id`),
  CONSTRAINT `complaint_ibfk_4` FOREIGN KEY (`assigned_agency_id`) REFERENCES `agency` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for table `contract`

CREATE TABLE `contract` (
  `id` char(36) NOT NULL,
  `project_id` char(36) NOT NULL,
  `contractor_id` char(36) NOT NULL,
  `awarded_by_agency_id` char(36) NOT NULL,
  `contract_no` varchar(100) NOT NULL,
  `procurement_method` enum('open_tender','restricted_tender','direct_procurement','design_build','framework_agreement','emergency') NOT NULL,
  `awarded_amount` decimal(20,2) NOT NULL,
  `current_contract_value` decimal(20,2) NOT NULL,
  `currency` char(3) DEFAULT 'KES',
  `awarded_date` date NOT NULL,
  `planned_completion_date` date NOT NULL,
  `status` enum('active','completed','terminated','suspended','disputed','under_variation') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contract_no` (`contract_no`),
  KEY `project_id` (`project_id`),
  KEY `contractor_id` (`contractor_id`),
  KEY `awarded_by_agency_id` (`awarded_by_agency_id`),
  CONSTRAINT `contract_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`),
  CONSTRAINT `contract_ibfk_2` FOREIGN KEY (`contractor_id`) REFERENCES `contractor` (`id`),
  CONSTRAINT `contract_ibfk_3` FOREIGN KEY (`awarded_by_agency_id`) REFERENCES `agency` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for table `contract_variation`

CREATE TABLE `contract_variation` (
  `id` char(36) NOT NULL,
  `contract_id` char(36) NOT NULL,
  `variation_no` int NOT NULL,
  `variation_type` enum('scope_change','value_increase','value_decrease','timeline_extension','timeline_reduction','scope_and_value','emergency') NOT NULL,
  `change_description` text NOT NULL,
  `amount_change` decimal(18,2) NOT NULL,
  `cumulative_variation_pct` decimal(7,2) NOT NULL,
  `approval_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `contract_id` (`contract_id`),
  CONSTRAINT `contract_variation_ibfk_1` FOREIGN KEY (`contract_id`) REFERENCES `contract` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for table `contractor`

CREATE TABLE `contractor` (
  `id` char(36) NOT NULL,
  `location_id` char(36) DEFAULT NULL,
  `entity_type` enum('company','sole_proprietor','consortium','joint_venture','ngo','cooperative') NOT NULL,
  `company_name` varchar(300) NOT NULL,
  `registration_no` varchar(60) NOT NULL,
  `tax_pin` varchar(20) DEFAULT NULL,
  `nca_license_no` varchar(60) DEFAULT NULL,
  `performance_score` decimal(4,2) DEFAULT '5.00',
  `contracts_awarded` int DEFAULT '0',
  `contracts_completed` int DEFAULT '0',
  `contracts_stalled` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `project_id` char(34) DEFAULT NULL,
  `contractor_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `registration_no` (`registration_no`),
  UNIQUE KEY `tax_pin` (`tax_pin`),
  KEY `location_id` (`location_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `contractor_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`),
  CONSTRAINT `contractor_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for table `disbursement`

CREATE TABLE `disbursement` (
  `id` char(36) NOT NULL,
  `project_id` char(36) NOT NULL,
  `contract_id` char(36) DEFAULT NULL,
  `milestone_id` char(36) DEFAULT NULL,
  `recipient_id` char(36) NOT NULL,
  `authorized_by` char(36) NOT NULL,
  `payment_type` enum('advance','progress_payment','final_payment','retention_release','emergency') NOT NULL,
  `amount` decimal(20,2) NOT NULL,
  `withholding_tax` decimal(18,2) DEFAULT '0.00',
  `net_amount` decimal(20,2) GENERATED ALWAYS AS ((`amount` - `withholding_tax`)) STORED,
  `disbursement_date` date NOT NULL,
  `payment_reference` varchar(150) NOT NULL,
  `hash` char(64) NOT NULL,
  `prev_hash` char(64) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payment_reference` (`payment_reference`),
  KEY `project_id` (`project_id`),
  KEY `contract_id` (`contract_id`),
  KEY `milestone_id` (`milestone_id`),
  KEY `recipient_id` (`recipient_id`),
  KEY `authorized_by` (`authorized_by`),
  CONSTRAINT `disbursement_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`),
  CONSTRAINT `disbursement_ibfk_2` FOREIGN KEY (`contract_id`) REFERENCES `contract` (`id`),
  CONSTRAINT `disbursement_ibfk_3` FOREIGN KEY (`milestone_id`) REFERENCES `milestone` (`id`),
  CONSTRAINT `disbursement_ibfk_4` FOREIGN KEY (`recipient_id`) REFERENCES `contractor` (`id`),
  CONSTRAINT `disbursement_ibfk_5` FOREIGN KEY (`authorized_by`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for table `location`

CREATE TABLE `location` (
  `id` char(36) NOT NULL,
  `parent_id` char(36) DEFAULT NULL,
  `level` enum('country','county','constituency','ward','sub_ward') NOT NULL,
  `name` varchar(150) NOT NULL,
  `code` varchar(30) NOT NULL,
  `population` int DEFAULT NULL,
  `area_sqkm` decimal(10,2) DEFAULT NULL,
  `governor_mp_name` varchar(150) DEFAULT NULL,
  `country_code` char(2) NOT NULL DEFAULT 'KE',
  `geojson_boundary` text,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `location_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `location` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for table `milestone`

CREATE TABLE `milestone` (
  `id` char(36) NOT NULL,
  `project_id` char(36) NOT NULL,
  `verified_by` char(36) DEFAULT NULL,
  `milestone_no` int NOT NULL,
  `title` varchar(300) NOT NULL,
  `planned_date` date NOT NULL,
  `actual_date` date DEFAULT NULL,
  `completion_pct` decimal(5,2) DEFAULT '0.00',
  `verification_status` enum('pending','verified','disputed','waived') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  KEY `verified_by` (`verified_by`),
  CONSTRAINT `milestone_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`id`) ON DELETE CASCADE,
  CONSTRAINT `milestone_ibfk_2` FOREIGN KEY (`verified_by`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for table `project`

CREATE TABLE `project` (
  `id` char(36) NOT NULL,
  `location_id` char(36) NOT NULL,
  `agency_id` char(36) NOT NULL,
  `title` varchar(300) NOT NULL,
  `description` text NOT NULL,
  `category` enum('road','bridge','hospital','school','water','energy','housing','sanitation','ict','other') NOT NULL,
  `status` enum('planning','tendering','active','stalled','completed','cancelled','under_review') DEFAULT 'planning',
  `funding_source` enum('national_govt','county_govt','cdf','world_bank','afdb','usaid','eu','giz','other_donor','ppp') NOT NULL,
  `funding_source_detail` varchar(255) DEFAULT NULL,
  `total_budget_kes` decimal(20,2) NOT NULL,
  `gps_lat` decimal(10,8) DEFAULT NULL,
  `gps_lng` decimal(11,8) DEFAULT NULL,
  `location_description` varchar(500) DEFAULT NULL,
  `start_date` date NOT NULL,
  `planned_end_date` date DEFAULT NULL,
  `revised_end_date` date DEFAULT NULL,
  `completion_pct_official` decimal(5,2) DEFAULT '0.00',
  `completion_pct_citizen` decimal(5,2) DEFAULT NULL,
  `anomaly_score` decimal(5,2) DEFAULT '0.00',
  `anomaly_flags` json DEFAULT NULL,
  `ocds_ocid` varchar(100) DEFAULT NULL,
  `oc4ids_project_id` varchar(100) DEFAULT NULL,
  `ppip_reference` varchar(100) DEFAULT NULL,
  `unit_quantity` decimal(12,2) DEFAULT NULL,
  `unit_type` varchar(50) DEFAULT NULL,
  `cost_per_unit_kes` decimal(18,2) DEFAULT NULL,
  `environmental_impact_ref` varchar(500) DEFAULT NULL,
  `community_resettlement` tinyint(1) DEFAULT '0',
  `visibility` enum('public','restricted','draft') DEFAULT 'public',
  `created_by` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ocds_ocid` (`ocds_ocid`),
  UNIQUE KEY `oc4ids_project_id` (`oc4ids_project_id`),
  KEY `location_id` (`location_id`),
  KEY `agency_id` (`agency_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `project_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`),
  CONSTRAINT `project_ibfk_2` FOREIGN KEY (`agency_id`) REFERENCES `agency` (`id`),
  CONSTRAINT `project_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Table structure for table `user`

CREATE TABLE `user` (
  `id` char(36) NOT NULL,
  `location_id` char(36) DEFAULT NULL,
  `agency_id` char(36) DEFAULT NULL,
  `role` enum('citizen','field_officer','agency_officer','county_admin','national_admin','system_auditor','api_client') NOT NULL,
  `verification_level` enum('anonymous','basic','phone_verified','id_verified','biometric_verified') NOT NULL,
  `national_id_hash` char(64) DEFAULT NULL,
  `phone_hash` char(64) DEFAULT NULL,
  `email_hash` char(64) DEFAULT NULL,
  `display_name` varchar(100) DEFAULT NULL,
  `trust_score` decimal(5,2) DEFAULT '50.00',
  `badge_tier` enum('none','bronze','silver','gold','platinum') DEFAULT 'none',
  `report_count` int DEFAULT '0',
  `accuracy_rate` decimal(5,2) DEFAULT NULL,
  `account_age_days` int DEFAULT '0',
  `device_fingerprint_hash` char(64) DEFAULT NULL,
  `preferred_language` char(5) DEFAULT 'en-KE',
  `last_active_at` timestamp NULL DEFAULT NULL,
  `velocity_hold` tinyint(1) DEFAULT '0',
  `deactivated` tinyint(1) DEFAULT '0',
  `deactivation_reason` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `national_id_hash` (`national_id_hash`),
  UNIQUE KEY `phone_hash` (`phone_hash`),
  KEY `location_id` (`location_id`),
  KEY `agency_id` (`agency_id`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`id`),
  CONSTRAINT `user_ibfk_2` FOREIGN KEY (`agency_id`) REFERENCES `agency` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

