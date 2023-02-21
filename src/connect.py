from PyQt6.QtSql import QSqlDatabase


def create_connection(DRIVER_NAME,
                      SERVER_NAME,
                      DATABASE_NAME
                      ):

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
