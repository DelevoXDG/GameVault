from PyQt6.QtSql import QSqlDatabase


def create_connection():
    DRIVER_NAME = 'SQL SERVER'
    SERVER_NAME = 'DELEVO-PC\SQLEXPRESS'
    DATABASE_NAME = 'STEAM'
    # UID='sa';
    # PWD='sa';
    conn_str = f"""
    DRIVER={{{DRIVER_NAME}}};
    SERVER={SERVER_NAME};
    DATABASE={DATABASE_NAME};
    Trusted_Connection=yes;
    """
    global db
    db = QSqlDatabase.addDatabase('QODBC')
    db.setDatabaseName(conn_str)
    if db.open() is True:
        print('Connection to SQL Server successful')
        return True
    else:
        print('Connection to SQL Server failed')
        return False
