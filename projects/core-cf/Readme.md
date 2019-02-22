#Snippets

##Regional Mapping
```yaml
Mappings:
  RegionMap:
    us-east-1:
      desc: US East (N. Virginia) Region
      name: ue1
    us-east-2:
      desc: US East (Ohio) Region
      name: ue2
    us-west-1:
      desc: US West (N. California) Region
      name: uw1
    us-west-2:
      desc: US West (Oregon) Region
      name: uw2
    us-gov-west-1:
      desc: AWS GovCloud (US)
      name: ug1
    ca-central-1:
      desc: Canada (Central) Region
      name: cc1
    sa-east-1:
      desc: South America (São Paulo) Region
      name: se1
    eu-west-1:
      desc: EU (Ireland) Region
      name: ew1
    eu-west-2:
      desc: EU (London) Region
      name: ew2
    eu-west-3:
      desc: EU (Paris) Region
      name: ew3
    eu-central-1:
      desc: EU (Frankfurt) Region
      name: ec1
    cn-north-1:
      desc: China (Beijing) Region
      name: cn1
    ap-northeast-1:
      desc: Asia Pacific (Tokyo) Region
      name: an1
    ap-northeast-2:
      desc: Asia Pacific (Seoul) Region
      name: an2
    ap-northeast-3:
      desc: Asia Pacific (Osaka-Local) Region
      name: an3
    ap-south-1:
      desc: Asia Pacific (Mumbai) Region
      name: as1
    ap-southeast-1:
      desc: Asia Pacific (Singapore) Region
      name: ae1
    ap-southeast-2:
      desc: Asia Pacific (Sydney) Region
      name: ae2
```
###Example Usage
```yaml
Id: !Sub
  - ${owner}-${env}-${region}-${service}-kms-key
  - {region: !FindInMap [RegionMap, !Ref 'AWS::Region', name]}

```

##Security Group Mappings
```json
{
  "Mappings": {
    "ssh": {
      "dev": {
        "SecurityGroupIngress": [
          {"IpProtocol": "tcp", "FromPort": 22, "ToPort": 22, "CidrIp": "10.78.0.0/15",         "Description": "WEX SoPo VPN Traffic"},
          {"IpProtocol": "tcp", "FromPort": 22, "ToPort": 22, "CidrIp": "10.178.32.0/21",       "Description": "WEX remoteaccess VPN Traffic"}
        ],
        "SecurityGroupEgress": [
          {"IpProtocol": -1, "CidrIp": "127.0.0.1/32", "Description": "Localhost Loopback"}
        ]
      },
      "stage": {
        "SecurityGroupIngress": [
          {"IpProtocol": "tcp", "FromPort": 22, "ToPort": 22, "CidrIp": "10.78.0.0/15",         "Description": "WEX SoPo VPN Traffic"},
          {"IpProtocol": "tcp", "FromPort": 22, "ToPort": 22, "CidrIp": "10.178.32.0/21",       "Description": "WEX remoteaccess VPN Traffic"}
        ],
        "SecurityGroupEgress": [
          {"IpProtocol": -1, "CidrIp": "127.0.0.1/32", "Description": "Localhost Loopback"}
        ]
      },
      "prod": {
        "SecurityGroupIngress": [
          {"IpProtocol": "tcp", "FromPort": 22, "ToPort": 22, "CidrIp": "10.78.0.0/15",         "Description": "WEX SoPo VPN Traffic"},
          {"IpProtocol": "tcp", "FromPort": 22, "ToPort": 22, "CidrIp": "10.178.32.0/21",       "Description": "WEX remoteaccess VPN Traffic"}
        ],
        "SecurityGroupEgress": [
          {"IpProtocol": -1, "CidrIp": "127.0.0.1/32", "Description": "Localhost Loopback"}
        ]
      }
    },
    "rdp": {
      "dev": {
        "SecurityGroupIngress": [
          {"IpProtocol": "tcp", "FromPort": 3389, "ToPort": 3389, "CidrIp": "10.78.0.0/15",         "Description": "WEX SoPo VPN Traffic"},
          {"IpProtocol": "tcp", "FromPort": 3389, "ToPort": 3389, "CidrIp": "10.178.32.0/21",       "Description": "WEX remoteaccess VPN Traffic"}
        ],
        "SecurityGroupEgress": [
          {"IpProtocol": -1, "CidrIp": "127.0.0.1/32", "Description": "Localhost Loopback"}
        ]
      },
      "stage": {
        "SecurityGroupIngress": [
          {"IpProtocol": "tcp", "FromPort": 3389, "ToPort": 3389, "CidrIp": "10.78.0.0/15",         "Description": "WEX SoPo VPN Traffic"},
          {"IpProtocol": "tcp", "FromPort": 3389, "ToPort": 3389, "CidrIp": "10.178.32.0/21",       "Description": "WEX remoteaccess VPN Traffic"}
        ],
        "SecurityGroupEgress": [
          {"IpProtocol": -1, "CidrIp": "127.0.0.1/32", "Description": "Localhost Loopback"}
        ]
      },
      "prod": {
        "SecurityGroupIngress": [
          {"IpProtocol": "tcp", "FromPort": 3389, "ToPort": 3389, "CidrIp": "10.78.0.0/15",         "Description": "WEX SoPo VPN Traffic"},
          {"IpProtocol": "tcp", "FromPort": 3389, "ToPort": 3389, "CidrIp": "10.178.32.0/21",       "Description": "WEX remoteaccess VPN Traffic"}
        ],
        "SecurityGroupEgress": [
          {"IpProtocol": -1, "CidrIp": "127.0.0.1/32", "Description": "Localhost Loopback"}
        ]
      }
    },
    "networkReachability": {
      "dev": {
        "SecurityGroupIngress": [
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.78.0.0/15",         "Description": "WEX SoPo VPN Traffic"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.178.32.0/21",       "Description": "WEX remoteaccess VPN Traffic"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.94.49.0/24",        "Description": "Fleet Dev Private-Subnet-1a"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.94.50.0/24",        "Description": "Fleet Dev Private-Subnet-1b"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.94.51.0/24",        "Description": "Fleet Dev Private-Subnet-1c"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "172.28.160.0/21",      "Description": "Private subnet for Dev env from PWM Datacenter"}
        ],
        "SecurityGroupEgress": [
          {"IpProtocol": -1, "CidrIp": "127.0.0.1/32", "Description": "Localhost Loopback"}
        ]
      },
      "stage": {
        "SecurityGroupIngress": [
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.78.0.0/15",         "Description": "WEX SoPo VPN Traffic"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.178.32.0/21",       "Description": "WEX remoteaccess VPN Traffic"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.94.41.0/24",        "Description": "Fleet Stage Private-Subnet-1a"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.94.42.0/24",        "Description": "Fleet Stage Private-Subnet-1b"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.94.43.0/24",        "Description": "Fleet Stage Private-Subnet-1c"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "172.18.32.0/21",       "Description": "Private subnet for Stage env from APA Datacenter"}
        ],
        "SecurityGroupEgress": [
          {"IpProtocol": -1, "CidrIp": "127.0.0.1/32", "Description": "Localhost Loopback"}
        ]
      },
      "prod": {
        "SecurityGroupIngress": [
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.78.0.0/15",         "Description": "WEX SoPo VPN Traffic"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.178.32.0/21",       "Description": "WEX remoteaccess VPN Traffic"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.94.33.0/24",        "Description": "Fleet Prod Private-Subnet-1a"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.94.34.0/24",        "Description": "Fleet Prod Private-Subnet-1b"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "10.94.35.0/24",        "Description": "Fleet Prod Private-Subnet-1c"},
          {"IpProtocol": "icmp", "FromPort": 8, "ToPort": 0, "CidrIp": "172.17.32.0/21",       "Description": "Private subnet for Prod env from APA Datacenter"}
        ],
        "SecurityGroupEgress": [
          {"IpProtocol": -1, "CidrIp": "127.0.0.1/32", "Description": "Localhost Loopback"}
        ]
      }
    }
  }
}
```
```yaml
Mappings:
  ssh:
    dev:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 22
        ToPort: 22
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
      - IpProtocol: tcp
        FromPort: 22
        ToPort: 22
        CidrIp: 10.178.32.0/21
        Description: WEX remoteaccess VPN Traffic
      SecurityGroupEgress:
      - IpProtocol: -1
        CidrIp: 127.0.0.1/32
        Description: Localhost Loopback
    stage:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 22
        ToPort: 22
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
      - IpProtocol: tcp
        FromPort: 22
        ToPort: 22
        CidrIp: 10.178.32.0/21
        Description: WEX remoteaccess VPN Traffic
      SecurityGroupEgress:
      - IpProtocol: -1
        CidrIp: 127.0.0.1/32
        Description: Localhost Loopback
    prod:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 22
        ToPort: 22
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
      - IpProtocol: tcp
        FromPort: 22
        ToPort: 22
        CidrIp: 10.178.32.0/21
        Description: WEX remoteaccess VPN Traffic
      SecurityGroupEgress:
      - IpProtocol: -1
        CidrIp: 127.0.0.1/32
        Description: Localhost Loopback
  rdp:
    dev:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 3389
        ToPort: 3389
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
      - IpProtocol: tcp
        FromPort: 3389
        ToPort: 3389
        CidrIp: 10.178.32.0/21
        Description: WEX remoteaccess VPN Traffic
      SecurityGroupEgress:
      - IpProtocol: -1
        CidrIp: 127.0.0.1/32
        Description: Localhost Loopback
    stage:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 3389
        ToPort: 3389
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
      - IpProtocol: tcp
        FromPort: 3389
        ToPort: 3389
        CidrIp: 10.178.32.0/21
        Description: WEX remoteaccess VPN Traffic
      SecurityGroupEgress:
      - IpProtocol: -1
        CidrIp: 127.0.0.1/32
        Description: Localhost Loopback
    prod:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 3389
        ToPort: 3389
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
      - IpProtocol: tcp
        FromPort: 3389
        ToPort: 3389
        CidrIp: 10.178.32.0/21
        Description: WEX remoteaccess VPN Traffic
      SecurityGroupEgress:
      - IpProtocol: -1
        CidrIp: 127.0.0.1/32
        Description: Localhost Loopback
  networkReachability:
    dev:
      SecurityGroupIngress:
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.178.32.0/21
        Description: WEX remoteaccess VPN Traffic
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.49.0/24
        Description: Fleet Dev Private-Subnet-1a
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.50.0/24
        Description: Fleet Dev Private-Subnet-1b
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.51.0/24
        Description: Fleet Dev Private-Subnet-1c
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 172.28.160.0/21
        Description: Private subnet for Dev env from PWM Datacenter
      SecurityGroupEgress:
      - IpProtocol: -1
        CidrIp: 127.0.0.1/32
        Description: Localhost Loopback
    stage:
      SecurityGroupIngress:
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.78.0.0/15
        Description: WEX VPN employee traffic
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.178.32.0/21
        Description: WEX remoteaccess VPN Traffic
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.41.0/24
        Description: Fleet Stage Private-Subnet-1a
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.42.0/24
        Description: Fleet Stage Private-Subnet-1b
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.43.0/24
        Description: Fleet Stage Private-Subnet-1c
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 172.18.32.0/21
        Description: Private subnet for Stage env from APA Datacenter
      SecurityGroupEgress:
      - IpProtocol: -1
        CidrIp: 127.0.0.1/32
        Description: Localhost Loopback
    prod:
      SecurityGroupIngress:
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.78.0.0/15
        Description: WEX VPN employee traffic
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.178.32.0/21
        Description: WEX remoteaccess VPN Traffic
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.33.0/24
        Description: Fleet Prod Private-Subnet-1a
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.34.0/24
        Description: Fleet Prod Private-Subnet-1b
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.35.0/24
        Description: Fleet Prod Private-Subnet-1c
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 172.17.32.0/21
        Description: Private subnet for Prod env from APA Datacenter
      SecurityGroupEgress:
      - IpProtocol: -1
        CidrIp: 127.0.0.1/32
        Description: Localhost Loopback
```

###Example Usage:
```yaml
Resources:
  SecGrpSsh:
    Type: 'AWS::EC2::SecurityGroup'
    Description: Allow SSH access to *nix based EC2 Instances from WEX Corporate Network
    Properties:
      VpcId: !Ref vpc
      GroupDescription: Instances needing SSH access from WEX Corporate
      GroupName: !Sub '${lineOfBusiness}-${envType}-account-ssh-ingress-sg'
      SecurityGroupIngress: !FindInMap [ssh, !Ref envType, SecurityGroupIngress]
      SecurityGroupEgress: !FindInMap [ssh, !Ref envType, SecurityGroupEgress]
      Tags:
      - Key: Name
        Value: Account - Service - SSH Ingress
```

##Misc
```yaml
Mappings:
  internalALB:
    dev:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.78.0.0/15
        Description: WEX VPN employee traffic
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.49.0/24
        Description: Fleet Dev Private-Subnet-1a
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.50.0/24
        Description: Fleet Dev Private-Subnet-1b
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.51.0/24
        Description: Fleet Dev Private-Subnet-1c
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 172.28.160.0/21
        Description: Private subnet for Dev env from PWM Datacenter
      SecurityGroupEgress:
      - CidrIp: 127.0.0.1/32
        IpProtocol: '-1'
    stage:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.78.0.0/15
        Description: WEX VPN employee traffic
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.41.0/24
        Description: Fleet Stage Private-Subnet-1a
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.42.0/24
        Description: Fleet Stage Private-Subnet-1b
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.43.0/24
        Description: Fleet Stage Private-Subnet-1c
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 172.18.32.0/21
        Description: Private subnet for Stage env from APA Datacenter
      SecurityGroupEgress:
      - CidrIp: 127.0.0.1/32
        IpProtocol: '-1'
    prod:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.78.0.0/15
        Description: WEX VPN employee traffic
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.33.0/24
        Description: Fleet Prod Private-Subnet-1a
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.34.0/24
        Description: Fleet Prod Private-Subnet-1b
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.35.0/24
        Description: Fleet Prod Private-Subnet-1c
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 172.17.32.0/21
        Description: Private subnet for Prod env from APA Datacenter
      SecurityGroupEgress:
      - CidrIp: 127.0.0.1/32
        IpProtocol: '-1'
  sshIngress:
    dev:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 22
        ToPort: 22
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
    stage:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 22
        ToPort: 22
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
    prod:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 22
        ToPort: 22
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
  rdpIngress:
    dev:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 3389
        ToPort: 3389
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
    stage:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 3389
        ToPort: 3389
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
    prod:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 3389
        ToPort: 3389
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
  ICMPEchoReplyIngress:
    dev:
      SecurityGroupIngress:
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.78.0.0/15
        Description: WEX SoPo VPN Traffic
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.49.0/24
        Description: Fleet Dev Private-Subnet-1a
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.50.0/24
        Description: Fleet Dev Private-Subnet-1b
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.51.0/24
        Description: Fleet Dev Private-Subnet-1c
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 172.28.160.0/21
        Description: Private subnet for Dev env from PWM Datacenter
      SecurityGroupIEgress: []
    stage:
      SecurityGroupIngress:
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.78.0.0/15
        Description: WEX VPN employee traffic
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.41.0/24
        Description: Fleet Stage Private-Subnet-1a
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.42.0/24
        Description: Fleet Stage Private-Subnet-1b
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.43.0/24
        Description: Fleet Stage Private-Subnet-1c
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 172.18.32.0/21
        Description: Private subnet for Stage env from APA Datacenter
      SecurityGroupIEgress: []
    prod:
      SecurityGroupIngress:
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.78.0.0/15
        Description: WEX VPN employee traffic
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.33.0/24
        Description: Fleet Prod Private-Subnet-1a
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.34.0/24
        Description: Fleet Prod Private-Subnet-1b
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 10.94.35.0/24
        Description: Fleet Prod Private-Subnet-1c
      - IpProtocol: icmp
        FromPort: 8
        ToPort: 0
        CidrIp: 172.17.32.0/21
        Description: Private subnet for Prod env from APA Datacenter
      SecurityGroupIEgress: []
  AppDynamicsAgent:
    dev:
      SecurityGroupEgress:
      - IpProtocol: tcp
        FromPort: 8181
        ToPort: 8181
        CidrIp: 172.28.160.174/32
        Description: Machine/App Agent (pwm-wex-1309 PWM Dev Datacenter)
    stage:
      SecurityGroupEgress:
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.192.32/27
        Description: Machine/App Agent (SecureCore-Prod Private-Subnet-1b)
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.192.64/27
        Description: Machine/App Agent (SecureCore-Prod Private-Subnet-1c)
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.192.96/27
        Description: Machine/App Agent (SecureCore-Prod Private-Subnet-1d)
    prod:
      SecurityGroupEgress:
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.192.32/27
        Description: Machine/App Agent (SecureCore-Prod Private-Subnet-1b)
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.192.64/27
        Description: Machine/App Agent (SecureCore-Prod Private-Subnet-1c)
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 10.94.192.96/27
        Description: Machine/App Agent (SecureCore-Prod Private-Subnet-1d)
  SumoLogicAgent:
    dev:
      SecurityGroupIngress: []
      SecurityGroupEgress:
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 0.0.0.0/0
        Description: 'SaaS Service, we can at least ensure outbound is encrypted'
    stage:
      SecurityGroupIngress: []
      SecurityGroupEgress:
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 0.0.0.0/0
        Description: 'SaaS Service, we can at least ensure outbound is encrypted'
    prod:
      SecurityGroupIngress: []
      SecurityGroupEgress:
      - IpProtocol: tcp
        FromPort: 443
        ToPort: 443
        CidrIp: 0.0.0.0/0
        Description: 'SaaS Service, we can at least ensure outbound is encrypted'
  SplunkAgent:
    dev:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 9089
        ToPort: 9089
        CidrIp: 10.99.41.0/24
        Description: DeploymentClient - Mgmt Port (FleetWebDev Private-Subnet-1a)
      - IpProtocol: tcp
        FromPort: 9089
        ToPort: 9089
        CidrIp: 10.99.42.0/24
        Description: DeploymentClient - Mgmt Port (FleetWebDev Private-Subnet-1b)
      - IpProtocol: tcp
        FromPort: 9089
        ToPort: 9089
        CidrIp: 10.99.43.0/24
        Description: DeploymentClient - Mgmt Port (FleetWebDev Private-Subnet-1c)
      SecurityGroupEgress:
      - IpProtocol: tcp
        FromPort: 8089
        ToPort: 8089
        CidrIp: 10.99.41.0/24
        Description: Log Forwarder Port (FleetWebDev Private-Subnet-1a)
      - IpProtocol: tcp
        FromPort: 8089
        ToPort: 8089
        CidrIp: 10.99.42.0/24
        Description: Log Forwarder Port (FleetWebDev Private-Subnet-1b)
      - IpProtocol: tcp
        FromPort: 8089
        ToPort: 8089
        CidrIp: 10.99.43.0/24
        Description: Log Forwarder Port (FleetWebDev Private-Subnet-1c)
    stage:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 9089
        ToPort: 9089
        CidrIp: 10.94.1.0/24
        Description: DeploymentClient - Mgmt Port (CoreServices-Prod Private-Subnet-1a)
      - IpProtocol: tcp
        FromPort: 9089
        ToPort: 9089
        CidrIp: 10.94.2.0/24
        Description: DeploymentClient - Mgmt Port (CoreServices-Prod Private-Subnet-1b)
      - IpProtocol: tcp
        FromPort: 9089
        ToPort: 9089
        CidrIp: 10.94.0.0/24
        Description: DeploymentClient - Mgmt Port (CoreServices-Prod Private-Subnet-1c)
      SecurityGroupEgress:
      - IpProtocol: tcp
        FromPort: 8089
        ToPort: 8089
        CidrIp: 10.94.1.0/24
        Description: Log Forwarder Port (CoreServices-Prod Private-Subnet-1a)
      - IpProtocol: tcp
        FromPort: 8089
        ToPort: 8089
        CidrIp: 10.94.2.0/24
        Description: Log Forwarder Port (CoreServices-Prod Private-Subnet-1b)
      - IpProtocol: tcp
        FromPort: 8089
        ToPort: 8089
        CidrIp: 10.94.0.0/24
        Description: Log Forwarder Port (CoreServices-Prod Private-Subnet-1c)
    prod:
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 9089
        ToPort: 9089
        CidrIp: 10.94.1.0/24
        Description: DeploymentClient - Mgmt Port (CoreServices-Prod Private-Subnet-1a)
      - IpProtocol: tcp
        FromPort: 9089
        ToPort: 9089
        CidrIp: 10.94.2.0/24
        Description: DeploymentClient - Mgmt Port (CoreServices-Prod Private-Subnet-1b)
      - IpProtocol: tcp
        FromPort: 9089
        ToPort: 9089
        CidrIp: 10.94.0.0/24
        Description: DeploymentClient - Mgmt Port (CoreServices-Prod Private-Subnet-1c)
      SecurityGroupEgress:
      - IpProtocol: tcp
        FromPort: 8089
        ToPort: 8089
        CidrIp: 10.94.1.0/24
        Description: Log Forwarder Port (CoreServices-Prod Private-Subnet-1a)
      - IpProtocol: tcp
        FromPort: 8089
        ToPort: 8089
        CidrIp: 10.94.2.0/24
        Description: Log Forwarder Port (CoreServices-Prod Private-Subnet-1b)
      - IpProtocol: tcp
        FromPort: 8089
        ToPort: 8089
        CidrIp: 10.94.0.0/24
        Description: Log Forwarder Port (CoreServices-Prod Private-Subnet-1c)

```
