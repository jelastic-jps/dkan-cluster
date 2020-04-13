
var resp = {
  result: 0,
  ssl: !!jelastic.billing.account.GetQuotas('environment.jelasticssl.enabled').array[0].value,
  nodes: [{
    nodeType: "storage",
    count: 3,
    tag: "2.0-7.2",
    cluster: true,
    flexibleCloudlets: ${settings.st_flexibleCloudlets:8},
    fixedCloudlets: ${settings.st_fixedCloudlets:1},
    diskLimit: ${settings.st_diskLimit:100},
    nodeGroup: "storage",
    displayName: "Storage"
  }]
}

resp.nodes.push({
  nodeType: "mysql5",
  count: 2,
  flexibleCloudlets: ${settings.db_flexibleCloudlets:16},
  fixedCloudlets: ${settings.db_fixedCloudlets:1},
  diskLimit: ${settings.db_diskLimit:10},
  nodeGroup: "sqldb",
  skipNodeEmails: true,
  displayName: "DB Server"
})

resp.nodes.push({
  nodeType: "nginx",
  tag: "1.16.1",
  count: 2,
  flexibleCloudlets: ${settings.bl_flexibleCloudlets:8},
  fixedCloudlets: ${settings.bl_fixedCloudlets:1},
  diskLimit: ${settings.bl_diskLimit:10},
  nodeGroup: "bl",
  scalingMode: "STATEFUL",
  displayName: "Load balancer"
}, {
  nodeType: "apache2",
  tag: "2.4.43-php-7.3.16",
  count: ${settings.cp_count:2},
  flexibleCloudlets: ${settings.cp_flexibleCloudlets:8},                  
  fixedCloudlets: ${settings.cp_fixedCloudlets:1},
  diskLimit: ${settings.cp_diskLimit:10},
  nodeGroup: "cp",
  scalingMode: "STATELESS",
  displayName: "AppServer",
  env: {
      SERVER_WEBROOT: "/var/www/webroot/ROOT",
      REDIS_ENABLED: "true"
  }
})

return resp;
