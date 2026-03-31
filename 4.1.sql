CREATE TABLE Log (
    log_id INT           IDENTITY(1,1) PRIMARY KEY,
    old_value    NVARCHAR(255) NULL,
    new_value    NVARCHAR(255) NULL,
    user_name    NVARCHAR(100) NOT NULL,
    type_action  NVARCHAR(50)  NOT NULL,
    datetime_action DATETIME   NOT NULL DEFAULT GETDATE()
);