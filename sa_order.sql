-- ============================================
-- 1. MASTER: sa_order
-- ============================================
CREATE TABLE sa_order (
    RefID               CHAR(36)        NOT NULL COMMENT 'Khóa chính - ID đơn hàng (UUID)',
    RefNo               VARCHAR(100)    NOT NULL COMMENT 'Số đơn hàng',
    RefDate             DATETIME        NOT NULL COMMENT 'Ngày lập đơn hàng',

    CustomerID          CHAR(36)        NULL COMMENT 'ID khách hàng (NULL nếu là khách lẻ)',
    CustomerCode        VARCHAR(50)     NULL COMMENT 'Mã khách hàng (snapshot tại thời điểm bán)',
    CustomerName        VARCHAR(255)    NULL COMMENT 'Tên khách hàng (snapshot tại thời điểm bán)',

    CashierName         VARCHAR(255)    NOT NULL COMMENT 'Tên nhân viên thu ngân lập đơn',

    StockID             CHAR(36)        NOT NULL COMMENT 'ID kho xuất hàng',
    StockCode           VARCHAR(50)     NOT NULL COMMENT 'Mã kho',
    StockName           VARCHAR(255)    NOT NULL COMMENT 'Tên kho',

    SubTotalAmount      DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Tổng tiền hàng (chưa giảm giá, chưa VAT)',
    DiscountAmount      DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Số tiền giảm giá trên tổng đơn',
    TaxAmount           DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Tiền thuế VAT',
    TotalAmount         DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Tổng tiền phải thanh toán = SubTotalAmount - DiscountAmount + TaxAmount',
    PaidAmount          DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Số tiền khách đã trả',
    ChangeAmount        DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Tiền thối lại cho khách = PaidAmount - TotalAmount',

    PaymentMethod       TINYINT         NOT NULL COMMENT 'Hình thức thanh toán: 1=Tiền mặt, 2=Thẻ, 3=Chuyển khoản, 4=Ví điện tử, 5=Kết hợp',
    OrderStatus         TINYINT         NOT NULL COMMENT 'Trạng thái đơn: 1=Nháp (Draft), 2=Chờ thanh toán (Pending), 3=Hoàn thành (Completed), 4=Đã hủy (Cancelled), 5=Trả hàng (Returned)',

    Description         VARCHAR(500)    NULL COMMENT 'Ghi chú đơn hàng',

    CreatedDate         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Ngày tạo bản ghi',
    CreatedBy           VARCHAR(100)    NULL COMMENT 'Người tạo bản ghi (username/userID)',
    ModifiedDate        DATETIME        NULL COMMENT 'Ngày sửa bản ghi gần nhất',
    ModifiedBy          VARCHAR(100)    NULL COMMENT 'Người sửa bản ghi gần nhất',

    PRIMARY KEY (RefID),

    KEY IDX_sa_order_RefDate    (RefDate),
    KEY IDX_sa_order_CustomerID (CustomerID),
    KEY IDX_sa_order_StockID    (StockID),
    KEY IDX_sa_order_OrderStatus(OrderStatus)
)
COMMENT = 'Đơn hàng bán - Master';


-- ============================================
-- 2. DETAIL: sa_order_detail
-- ============================================
CREATE TABLE sa_order_detail (
    RefDetailID         CHAR(36)        NOT NULL COMMENT 'Khóa chính - ID dòng chi tiết (UUID)',
    RefID               CHAR(36)        NOT NULL COMMENT 'FK - ID đơn hàng (liên kết sa_order.RefID)',

    InventoryItemID     CHAR(36)        NOT NULL COMMENT 'ID sản phẩm/hàng hóa',
    InventoryItemCode   VARCHAR(50)     NOT NULL COMMENT 'Mã sản phẩm (snapshot tại thời điểm bán)',
    InventoryItemName   VARCHAR(255)    NOT NULL COMMENT 'Tên sản phẩm (snapshot tại thời điểm bán)',

    Description         VARCHAR(500)    NULL COMMENT 'Diễn giải chi tiết dòng',

    UnitID              CHAR(36)        NULL COMMENT 'ID đơn vị tính',
    UnitName            VARCHAR(50)     NULL COMMENT 'Tên đơn vị tính (cái, kg, thùng,... - snapshot)',

    MainUnitID          CHAR(36)        NULL COMMENT 'ID đơn vị tính chính',
    MainUnitName        VARCHAR(50)     NULL COMMENT 'Tên đơn vị tính chính (cái, kg, thùng,... - snapshot)',

    Quantity            DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Số lượng bán (3 số thập phân cho hàng cân ký)',
    MainQuantity        DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Số lượng bán theo đơn vị tính chính (3 số thập phân cho hàng cân ký)',

    UnitPrice           DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Đơn giá bán tại thời điểm bán (snapshot)',
    MainUnitPrice       DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Đơn giá bán tại thời điểm bán theo đơn vị tính chính (snapshot)',

    DiscountRate        DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Tỷ lệ chiết khấu',
    DiscountAmount      DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Số tiền giảm giá trên dòng',

    VatRate             DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Tỷ lệ VAT',
    VatRateName         VARCHAR(25)     NULL COMMENT 'Tên VatRateName',
    VatAmount           DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Số tiền VAT',

    Amount              DECIMAL(24,10)  NOT NULL DEFAULT 0 COMMENT 'Thành tiền dòng = Quantity * UnitPrice - DiscountAmount',

    SortOrder           INT             NOT NULL DEFAULT 1 COMMENT 'Số thứ tự dòng chi tiết',

    CreatedDate         DATETIME        NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Ngày tạo bản ghi',
    CreatedBy           VARCHAR(100)    NULL COMMENT 'Người tạo bản ghi',
    ModifiedDate        DATETIME        NULL COMMENT 'Ngày sửa bản ghi gần nhất',
    ModifiedBy          VARCHAR(100)    NULL COMMENT 'Người sửa bản ghi gần nhất',

    PRIMARY KEY (RefDetailID),

    KEY IDX_sa_order_detail_RefID            (RefID),
    KEY IDX_sa_order_detail_InventoryItemID  (InventoryItemID),

    CONSTRAINT FK_sa_order_detail_sa_order
        FOREIGN KEY (RefID)
        REFERENCES sa_order (RefID)
        ON DELETE CASCADE
)
COMMENT = 'Đơn hàng bán - Chi tiết';
