CREATE TABLE sys_auditing_log (
    ID              CHAR(36)        NOT NULL COMMENT 'Khóa chính của bảng',

    Reference       TEXT            NULL COMMENT 'Tham chiếu',
    Message         LONGTEXT        NULL COMMENT 'Mô tả chi tiết hành động',

    ActionType      INT             NULL COMMENT 'Loại hành động',
    Action          VARCHAR(255)    NULL COMMENT 'Tên hành động',

    UserID          CHAR(36)        NOT NULL COMMENT 'UserID của người tạo',
    UserName        VARCHAR(255)    NULL COMMENT 'Username của người tạo ra hành động',

    ModelID         CHAR(36)        NULL COMMENT 'RefID của model thao tác',
    ModelName       TEXT            NULL COMMENT 'Tên model thao tác',

    IPAddress       VARCHAR(50)     NULL COMMENT 'Địa chỉ IP của người dùng',

    TenantID        CHAR(36)        NOT NULL COMMENT 'ID công ty',

    CreatedDate     DATETIME        NULL COMMENT 'Ngày tạo',
    CreatedBy       VARCHAR(150)    NULL COMMENT 'Người tạo',

    ModifiedDate    DATETIME        NULL COMMENT 'Ngày sửa',
    ModifiedBy      VARCHAR(150)    NULL COMMENT 'Người sửa',

    PRIMARY KEY (ID)
);