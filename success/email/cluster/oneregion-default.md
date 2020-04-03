**DKAN environment**: [${env.url}](${env.url})

Use the following credentials to access the admin panel:

**Admin Panel**: [${env.url}user/login/](${env.url}user/login/)  
**Login**: admin  
**Password**: ${globals.DKAN_ADMIN_PASS}  

Manage the database nodes using the next credentials:

**phpMyAdmin Panel**: [https://node${nodes.sqldb.master.id}-${env.domain}/](https://node${nodes.sqldb.master.id}-${env.domain}/)  
**Username**: ${globals.DB_USER}    
**Password**: ${globals.DB_PASS}  

