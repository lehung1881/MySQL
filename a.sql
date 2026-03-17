CREATE TABLE `sys_msc_user` (
  `UserID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci NOT NULL COMMENT 'Khóa chính bảng quản lý người dùng, khóa này là trườn user_id bên amis',
  `Inactive` tinyint NOT NULL DEFAULT '0' COMMENT 'Trạng thái hoạt động người dùng true: ngừng hoạt động, false: hoạt động bt',
  `FullName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Tên đầy đủ người dùng',
  `Email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Email người dùng',
  `MobilePhone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Số điện thoại người dùng',
  `OrganizationUnitName` longtext COLLATE utf8mb4_0900_as_ci COMMENT 'Mức độ truy cập dữ liệu',
  `MisaID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci NOT NULL COMMENT 'misa_id của người dùng',
  `AmisRoleType` int DEFAULT NULL COMMENT 'Vai trò của người dùng bên Amis platform',
  `CreatedBy` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Người tạo',
  `CreatedDate` datetime DEFAULT NULL COMMENT 'Ngày tạo',
  `ModifiedBy` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Người sửa đổi',
  `ModifiedDate` datetime DEFAULT NULL COMMENT 'Ngày thay đổi',
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_ci AVG_ROW_LENGTH=4096 COMMENT='Bảng quản lý người dùng';

CREATE TABLE `sys_msc_role` (
  `RoleID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci NOT NULL COMMENT 'Khóa chính của bảng',
  `IsSystem` tinyint NOT NULL COMMENT 'Có phải vai trò hệ thống không. True-ngầm định hệ thống và ngược lại',
  `RoleCode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Mã vai trò',
  `RoleName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Tên vai trò',
  `Description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Diễn giải vai trò',
  `SystemCode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Mã hệ thống',
  `Inactive` tinyint DEFAULT '0' COMMENT 'Trạng thái vai trò - true: ngừng sử dụng, false: đang sửa dụng',
  `CreatedBy` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Người tạo',
  `CreatedDate` datetime DEFAULT NULL COMMENT 'Ngày tạo',
  `ModifiedBy` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Người sửa đổi',
  `ModifiedDate` datetime DEFAULT NULL COMMENT 'Ngày thay đổi',
  PRIMARY KEY (`RoleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_ci AVG_ROW_LENGTH=780 COMMENT='Bảng vai trò';

CREATE TABLE `sys_msc_user_join_role` (
  `UserJoinRoleID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci NOT NULL COMMENT 'Khóa chính của bảng',
  `UserID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci NOT NULL COMMENT 'khóa ngoại liên kết bảng sys_msc_user',
  `RoleID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Khóa ngoại liên kết bảng sys_msc_role',
  `BranchID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Chi nhánh người dùng có quyền, nếu người dùng là admin trường này null',
  `BranchCode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Mã chi nhánh, xem trường này có cần gì ko',
  PRIMARY KEY (`UserJoinRoleID`),
  KEY `fk_sysmscuserjoinrole_roleid` (`RoleID`),
  KEY `fk_sysmscuserjoinrole_userid` (`UserID`),
  CONSTRAINT `fk_sysmscuserjoinrole_roleid` FOREIGN KEY (`RoleID`) REFERENCES `sys_msc_role` (`RoleID`) ON DELETE CASCADE,
  CONSTRAINT `fk_sysmscuserjoinrole_userid` FOREIGN KEY (`UserID`) REFERENCES `sys_msc_user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_ci COMMENT='Bảng mapping giữa người dùng và quyền';

CREATE TABLE `sys_msc_role_permission_maping` (
  `ID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci NOT NULL COMMENT 'Khóa chính của bảng',
  `RoleID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci NOT NULL COMMENT 'Khóa ngoại của bảng sys_msc_role',
  `SubSystemCode` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Mã màn hình',
  `ListPermission` json DEFAULT NULL COMMENT 'Danh sách các quyền ở màn hình này',
  `CreatedBy` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Người tạo',
  `CreatedDate` datetime DEFAULT NULL COMMENT 'Ngày tạo',
  `ModifiedBy` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT 'Người sửa đổi',
  `ModifiedDate` datetime DEFAULT NULL COMMENT 'Ngày thay đổi',
  PRIMARY KEY (`ID`),
  KEY `ix_sysmscrolepermissionmaping_roleid` (`RoleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_ci AVG_ROW_LENGTH=353 COMMENT='Bảng mapping giữa vai trò và quyền.';