import sqlite3

def create_connection(db_file):
    try:
        conn = sqlite3.connect(db_file, timeout=15.0)
    except Exception as e:
        print(e)
    return conn

def exec_query(conn, qry):
    c = conn.cursor()
    return c.execute(qry).fetchall()

def create_db(conn):
    createInteractionsTable="""CREATE TABLE IF NOT EXISTS interactions (
            id integer PRIMARY KEY,
            url text,
            script_src text,
            client_ip text,
            referrer text,
            user_agent text,
            cookies text,
            local_storage text,
            session_storage text,
            page_dom text,
            browser_time integer,
            screenshot blob);"""

    exec_query(conn, createInteractionsTable)

def insert_interaction(conn, entry):

    columns = ', '.join(entry.keys())
    placeholders = "?" + ", ?" * (len(entry)-1)
    sql = 'INSERT INTO interactions ({}) VALUES ({});'.format(columns, placeholders)
    values = [int(x) if isinstance(x, bool) else x for x in entry.values()]

    c = conn.cursor()
    c.execute(sql, values)
    conn.commit()
