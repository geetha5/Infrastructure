Pass through https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/ELBv2.html#createListener-property
Only Difference is you need to provide the ServiceToken at the root.
```json
{
  "AWSTemplateFormatVersion": "2010-09-09",

  "Resources": {
    "ListenerHttpRedirectRule": {
      "Type": "Custom::ElasticLoadBalancingV2_Listener",
      "Properties": {
        "ServiceToken": "arn:aws:lambda:us-east-1:518554605247:function:cloud9-albListenerRedirect-albListenerRedirect-1F30S8SFKE8X4",
        "DefaultActions" : [{
          "Type": "redirect",
          "RedirectConfig": {
            "Protocol": "HTTPS",
            "Port": 443,
            "StatusCode": "HTTP_301"
          }
        }],
        "LoadBalancerArn" : {"Ref": "PublicAlb"},
        "Port" : 80,
        "Protocol" : "HTTP"
      },
      "DependsOn": ["PublicAlb"]
    },
    "ListenerHttpsDefaultRule": {
      "Type": "Custom::ElasticLoadBalancingV2_Listener",
      "Properties": {
        "ServiceToken": "arn:aws:lambda:us-east-1:518554605247:function:cloud9-albListenerRedirect-albListenerRedirect-1F30S8SFKE8X4",
        "DefaultActions": [{
          "Type": "fixed-response",
          "FixedResponseConfig": {"StatusCode": "404"}
        }],
        "LoadBalancerArn": {"Ref": "PublicAlb"},
        "Port": 443,
        "Protocol": "HTTPS",
        "SslPolicy": "ELBSecurityPolicy-TLS-1-2-Ext-2018-06",
        "Certificates": [{"CertificateArn": {"Ref": "HttpsCertExternal"}}]
      },
      "DependsOn": ["PublicAlb", "HttpsCertExternal"]
    },

```


```javascript
{
  DefaultActions: [ /* required */
    {
      Type: forward | authenticate-oidc | authenticate-cognito | redirect | fixed-response, /* required */
      AuthenticateCognitoConfig: {
        UserPoolArn: 'STRING_VALUE', /* required */
        UserPoolClientId: 'STRING_VALUE', /* required */
        UserPoolDomain: 'STRING_VALUE', /* required */
        AuthenticationRequestExtraParams: {
          '<AuthenticateCognitoActionAuthenticationRequestParamName>': 'STRING_VALUE',
          /* '<AuthenticateCognitoActionAuthenticationRequestParamName>': ... */
        },
        OnUnauthenticatedRequest: deny | allow | authenticate,
        Scope: 'STRING_VALUE',
        SessionCookieName: 'STRING_VALUE',
        SessionTimeout: 0
      },
      AuthenticateOidcConfig: {
        AuthorizationEndpoint: 'STRING_VALUE', /* required */
        ClientId: 'STRING_VALUE', /* required */
        ClientSecret: 'STRING_VALUE', /* required */
        Issuer: 'STRING_VALUE', /* required */
        TokenEndpoint: 'STRING_VALUE', /* required */
        UserInfoEndpoint: 'STRING_VALUE', /* required */
        AuthenticationRequestExtraParams: {
          '<AuthenticateOidcActionAuthenticationRequestParamName>': 'STRING_VALUE',
          /* '<AuthenticateOidcActionAuthenticationRequestParamName>': ... */
        },
        OnUnauthenticatedRequest: deny | allow | authenticate,
        Scope: 'STRING_VALUE',
        SessionCookieName: 'STRING_VALUE',
        SessionTimeout: 0
      },
      FixedResponseConfig: {
        StatusCode: 'STRING_VALUE', /* required */
        ContentType: 'STRING_VALUE',
        MessageBody: 'STRING_VALUE'
      },
      Order: 0,
      RedirectConfig: {
        StatusCode: HTTP_301 | HTTP_302, /* required */
        Host: 'STRING_VALUE',
        Path: 'STRING_VALUE',
        Port: 'STRING_VALUE',
        Protocol: 'STRING_VALUE',
        Query: 'STRING_VALUE'
      },
      TargetGroupArn: 'STRING_VALUE'
    },
    /* more items */
  ],
  LoadBalancerArn: 'STRING_VALUE', /* required */
  Port: 0, /* required */
  Protocol: HTTP | HTTPS | TCP, /* required */
  Certificates: [
    {
      CertificateArn: 'STRING_VALUE',
      IsDefault: true || false
    },
    /* more items */
  ],
  SslPolicy: 'STRING_VALUE'
};
```
