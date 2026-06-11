-- ============================================
-- BẢNG NGƯỜI DÙNG
-- ============================================

CREATE TABLE sys_msc_user (
    UserID              CHAR(36)        NOT NULL COMMENT 'Khóa chính bảng quản lý người dùng, khóa này là trường user_id bên AMIS',

    Inactive            TINYINT         NOT NULL DEFAULT 0 COMMENT 'Trạng thái hoạt động người dùng. 1: Ngừng hoạt động, 0: Hoạt động',

    FullName            VARCHAR(255)    NULL COMMENT 'Tên đầy đủ người dùng',
    Email               VARCHAR(100)    NULL COMMENT 'Email người dùng',
    MobilePhone         VARCHAR(50)     NULL COMMENT 'Số điện thoại người dùng',

    CreatedBy           VARCHAR(255)    NULL COMMENT 'Người tạo',
    CreatedDate         DATETIME        NULL COMMENT 'Ngày tạo',

    ModifiedBy          VARCHAR(255)    NULL COMMENT 'Người sửa đổi',
    ModifiedDate        DATETIME        NULL COMMENT 'Ngày thay đổi',

    PRIMARY KEY (UserID)
)
COMMENT = 'Bảng quản lý người dùng';


-- ============================================
-- BẢNG VAI TRÒ
-- ============================================

CREATE TABLE sys_msc_role (
    RoleID          CHAR(36)        NOT NULL COMMENT 'Khóa chính của bảng',

    IsSystem        TINYINT         NOT NULL COMMENT 'Có phải vai trò hệ thống không. 1: Hệ thống, 0: Tự tạo',

    RoleCode        VARCHAR(50)     NULL COMMENT 'Mã vai trò',
    RoleName        VARCHAR(255)    NULL COMMENT 'Tên vai trò',
    Description     VARCHAR(255)    NULL COMMENT 'Diễn giải vai trò',

    SystemCode      VARCHAR(50)     NULL COMMENT 'Mã hệ thống',

    Inactive        TINYINT         NULL DEFAULT 0 COMMENT 'Trạng thái vai trò. 1: Ngừng sử dụng, 0: Đang sử dụng',

    CreatedBy       VARCHAR(255)    NULL COMMENT 'Người tạo',
    CreatedDate     DATETIME        NULL COMMENT 'Ngày tạo',

    ModifiedBy      VARCHAR(255)    NULL COMMENT 'Người sửa đổi',
    ModifiedDate    DATETIME        NULL COMMENT 'Ngày thay đổi',

    PRIMARY KEY (RoleID)
)
COMMENT = 'Bảng vai trò';


-- ============================================
-- BẢNG MAPPING USER - ROLE
-- ============================================

CREATE TABLE sys_msc_user_role (
    UserRoleID          CHAR(36)        NOT NULL COMMENT 'Khóa chính của bảng',

    UserID              CHAR(36)        NOT NULL COMMENT 'Khóa ngoại liên kết bảng sys_msc_user',
    RoleID              CHAR(36)        NOT NULL COMMENT 'Khóa ngoại liên kết bảng sys_msc_role',

    PRIMARY KEY (UserRoleID),

    UNIQUE KEY uq_sys_msc_user_role (
        UserID,
        RoleID
    ),

    INDEX ix_sys_msc_user_role_userid (UserID),
    INDEX ix_sys_msc_user_role_roleid (RoleID),

    CONSTRAINT fk_sysmscuserrole_userid
        FOREIGN KEY (UserID)
        REFERENCES sys_msc_user(UserID)
        ON DELETE CASCADE,

    CONSTRAINT fk_sysmscuserrole_roleid
        FOREIGN KEY (RoleID)
        REFERENCES sys_msc_role(RoleID)
        ON DELETE CASCADE
)
COMMENT = 'Bảng mapping giữa người dùng và vai trò';


-- ============================================
-- BẢNG MAPPING ROLE - PERMISSION
-- ============================================

CREATE TABLE sys_msc_role_permission_mapping (
    ID                  CHAR(36)        NOT NULL COMMENT 'Khóa chính của bảng',

    RoleID              CHAR(36)        NOT NULL COMMENT 'Khóa ngoại của bảng sys_msc_role',

    SubSystemCode       VARCHAR(100)    NULL COMMENT 'Mã màn hình',
    ListPermission      JSON            NULL COMMENT 'Danh sách các quyền ở màn hình này',

    CreatedBy           VARCHAR(255)    NULL COMMENT 'Người tạo',
    CreatedDate         DATETIME        NULL COMMENT 'Ngày tạo',

    ModifiedBy          VARCHAR(255)    NULL COMMENT 'Người sửa đổi',
    ModifiedDate        DATETIME        NULL COMMENT 'Ngày thay đổi',

    PRIMARY KEY (ID),

    INDEX ix_sys_msc_role_permission_mapping_roleid (RoleID),

    CONSTRAINT fk_sysmscrolepermissionmapping_roleid
        FOREIGN KEY (RoleID)
        REFERENCES sys_msc_role(RoleID)
        ON DELETE CASCADE
)
COMMENT = 'Bảng mapping giữa vai trò và quyền';
