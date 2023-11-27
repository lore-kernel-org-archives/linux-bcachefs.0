Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="glXwSr33"
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12531B6
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Nov 2023 11:53:53 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ARIBgU1004300
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Nov 2023 11:53:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=yxaGn5gh9UzZBomP9TuoB2wOVd1fIIynBkAPExwLJZo=;
 b=glXwSr33h9QKKcfYrs3kzSYwR4ANGPuAyF1H23R8YMKgpwbcPf1c2Xb0kyiUvIR1uw0O
 mhH6bBIu9gn93RJw6M3aGSpjOrsAcKAbjqF22Im6t8myUUVdnBRtuejo063SLl1DND8n
 IpTx3T9WcME/GDc10/X7G+o6xsqx0gEftN2b5eIlHrBOJivHZeWMHKSplmUo1HD9TI37
 IMq0aMk/4KKp+xYVMpjgdNqjaVPuzR+SBCgQCmXw1sD36lZRyhRBSoPl5vZc5NRUPw19
 x9YuEG/foihj7kijFUEXiEmW3Av4oVEbHjtVfARMzmmuAjaXakXoZD3GmxSbkpW9Z1SW Bw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3umsc8uqdh-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Nov 2023 11:52:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwcXSRJlWVd5VLQsTXhS/IV0t4iogZ4qJh6FamMOp7r9Q7weWhNU8U5fQKSiXsptjpcgHK5J0bMnhy5zQyHJ80MEXT9oBAB87CWBs/FpostDC0+HajsgM6bVxQRlD59abXUarWLCWw9LZR3sg8EHnECS7ZCjRdf5KTNkI9o4Iv3iUp9XMUPFubRxaiDnziuxTBgJvT54pbW9yXXDMDjr+V6+ej07ZZDwZg8BvES/E1i8oBUW0+x0f7//0NtYExBtbTRImgREu0hLmlvAAUt0MSDtfs4wKUb2+7FO1WNBkCMAx5IdB5hVJjlZdhWc0HMuVyo34fPm3ME7M0+O4CoE8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5bhegiI7g77MXCZOFWsTAkEd5g5x3j6ZBqzAe4LF1E=;
 b=TDOkOgROxg6QCA4Pu9h+IIG2BjIvTg0MsXsX2MJSPp/igmUm54xrJw/SlzFxH3CioPeP7S+G26m+YEyJYpqziUYETK1fnHl/mFBZvgwXuSimguf+gIzx6XWXdvrL1w7PlAeeDyrrb3Dfmntua0AXXc7BQYCLgg5ZBGiBKqhAXW1K3LxUwOX0cbQNL94JA2L20n7TvNZSxkSGtqqpXA52bzFm6pqBnNEVo3jgOhyWsFp0c20hwWcSGWsmOLspG8y0FeSZI/zdT/rT03AswdDlfiWH+YKv8SITQYB3xU+BWYTI3j8jGmaJCRDMH1STlj39wG0VKIm83lFaoLz2Aq3SsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BY5PR15MB3667.namprd15.prod.outlook.com (2603:10b6:a03:1f9::18)
 by MW3PR15MB3802.namprd15.prod.outlook.com (2603:10b6:303:48::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.21; Mon, 27 Nov
 2023 19:52:05 +0000
Received: from BY5PR15MB3667.namprd15.prod.outlook.com
 ([fe80::cbea:e86f:62db:9b00]) by BY5PR15MB3667.namprd15.prod.outlook.com
 ([fe80::cbea:e86f:62db:9b00%3]) with mapi id 15.20.7046.015; Mon, 27 Nov 2023
 19:52:04 +0000
From: Nick Terrell <terrelln@meta.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
        Nick
 Terrell <nickrterrell@gmail.com>
Subject: Re: zstd error when used in bcachefs
Thread-Topic: zstd error when used in bcachefs
Thread-Index: AQHaHZUnQFf3VsiQEUO+8ekDfvFcSbCOmzna
Date: Mon, 27 Nov 2023 19:52:04 +0000
Message-ID: <93FB4B05-7C53-4771-A4CF-1D21AB837726@meta.com>
References: <20231122224208.procyauioksotuit@moria.home.lan>
In-Reply-To: <20231122224208.procyauioksotuit@moria.home.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR15MB3667:EE_|MW3PR15MB3802:EE_
x-ms-office365-filtering-correlation-id: 373afcb3-885a-4bf9-4c97-08dbef82548d
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 MB9EU9+ETN1eeO8PEl1jG7QpqbrAnRyvcO3djh8Az8TlJZb96LUvzUfqe5jHyQlwcZJbd4KRDHNy4li6pQBFyo7LKcFB/9mzqXAWhuvUD/wYsMe0TP6riWMhaumvCzBMU9xM0PxNvlkZWbAsDg4WIaMgnT7iB12Z3PRCSw4a2UR2QOT1BARXXoWO8YZ7bP6VAz6ZjyoyawZpBiyJVrF0wkGMRcRHkMg9r4IEkckQIPYHYDGI3CmSOaccBwrDiLphIF0UOhE6k3jsn9B/oglQ16Qk1stL5Sk+iGHcLp6EssIdDBKtjkOyDGJ0rhHJ//lKfPfypDhfNVmS5HcsW6ZzxeQV1hYnO3mVfhsuuDYIRcj/i+Hoqfmv9S7DASLkZdaoxHzPAQB2736xC9o4k2T2uKT/ZxtY4Sn9hsWGpK5RaEOtcrnB4Y9/ewvfJv/7gmMPg2FomhPl+7NWxZNN73ZkmIuKyWMskS/H5ymxt1iOVKqYOgzr43ayPq6GyJZpGzb2SH/giH8LDxkn6GN/0aSDQEp09YNDyfx3nkpsn7reFZ1UYyvnd5VtHK7jqnmx9pTv6703Qq3OEbJw9sQngGIcNAbCT8bDiHb4yIu/APBuUdJP288IqL90neKr30HstpNtwZCzT92gN1nuzmrEATXEGZgCXxXsIuAH2G8BT5BHfee5khVI7Ejk7kugJEI7nsWr
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3667.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(376002)(136003)(39860400002)(230173577357003)(230922051799003)(230273577357003)(186009)(64100799003)(451199024)(1800799012)(2616005)(6506007)(71200400001)(6512007)(53546011)(8936002)(4326008)(8676002)(5660300002)(86362001)(478600001)(966005)(6486002)(76116006)(316002)(91956017)(66946007)(66556008)(6916009)(54906003)(64756008)(66446008)(66476007)(38100700002)(83380400001)(122000001)(38070700009)(41300700001)(2906002)(33656002)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?cCtJankwTnlMMVpWOFdBVmdhRWVYYVBhczE1azRyQU91WklKblhaLzRTdUZ6?=
 =?utf-8?B?SGo3TFR1aXNmUFJnS2g1Mlp1RGZPa29sMGtoVytTOURvcklXZDNiWW5NWXFD?=
 =?utf-8?B?NVlEL1B4SGhaMlZpVVdWREVhOWJhbVVJbVpMNlZIWEMydW1pR3JMc2FuTThD?=
 =?utf-8?B?bkl3b0xiT1hZbG5xR0FxZ2FFNjNjREg5d1JlVnU0bGJDSGFzc1M5RTl1TEVp?=
 =?utf-8?B?ZzdWZFVuUTI2Y1RzMm9rbytMV3pzLzZJZDFwVno4S3l5c3BQaWxSYStxc0dv?=
 =?utf-8?B?Ni9nMHU0WTlGeUEvTWpZRlNzSDNiTS9BSk5CSHFZWGFJNUE4ZTRyUHpqLzRr?=
 =?utf-8?B?RnB6RmpJUXlZNWpQWTdCa2N4b3NEVEYzZVhXWElsOGwzZHJKZTFuWjdCdElu?=
 =?utf-8?B?YnlRbXdadnJRbHgxWWdRZEsydkxmVzk3cWZ4VzZadm1JelNxQnQ4MTB6cVRC?=
 =?utf-8?B?V1g2b3ppY2NGUFMrb0ZxcURsSHdnZG8wdVlxdkgzeXVYVDBLWDdjTzZIa3pI?=
 =?utf-8?B?WW5VbVJPeS80ZGxtUkJJOFd4dkdOaHl5cTlKQUN6Mkp0VkJ2bVM3ZEFzRFBG?=
 =?utf-8?B?T2w1VTZWbTQ3NGhZajZkeitXSTFFRC9TRjZPSCtlSWQyZGY2Wm9OQVpqN1BM?=
 =?utf-8?B?UDdjb085NGV2a1RQTW9JYUR6VDZBUUZLUTdEU1FkeWtPQVovdG45dXBQQWJn?=
 =?utf-8?B?WnFGN2F6ZHArZkJ3YWFubVp3eGQ1SmhxVEU0T2E2WUNhTnZEYUZlOERxbjBp?=
 =?utf-8?B?MFZ5TUFlZWpSUXR4UldLZ1J4eGdndkhCTWtwSzNMY3NwZSs1L3pYS0dnVmtM?=
 =?utf-8?B?RUx1WHQ5aW92Qi9keXB2enJmWWNHUkI5VVRHLzZsQTNKU1QvSW1wZW8waWcr?=
 =?utf-8?B?bGtxZFJLYWZ0TFo2d2lDREcvQnpDMzBhd0NjbDJNaWptUTF0OUp1Qm5Dajkr?=
 =?utf-8?B?SVJuNUY4K0YvdmVUbCs5YTZjdVBxcS9ubnRodmtFUDNkdXJNQVBtOUsxaXJj?=
 =?utf-8?B?SEUxL1krRjdMYzFwTjArZ3I4Y2xpRmxiUERybHBKOStkWnkvdHNOMlZ3ZUVL?=
 =?utf-8?B?WWZiN0RaMnVXQVowbmZheVVzK1BZcVpkOU5KZjV4SnVEdGJobnR2UWwvZU9s?=
 =?utf-8?B?eTBtRnJXTENXOXBFRXQ3R3AxbnFNS1h2cTlrMzVTOEZTSm10UG5YLzVSMzRV?=
 =?utf-8?B?Q0VsSGhtUHlGRnRCaXFOazJhVFJIZFVJUjJuR01wd1pldW9BellyWXRGTFdC?=
 =?utf-8?B?aXpKWGVlN3RkK25YRHdCMzE1cXJxTFhza1RCOTBtU2pQWEl0N3NIWFFMVWhC?=
 =?utf-8?B?bjN3cGZuZHh1QWdIY2NOamE2UkNYempkRm9xTG9iMWtxUTVqRlkyL2h3ZTA3?=
 =?utf-8?B?TWNkdWUrbUsrYWxCai9sNHp6WXRFOHBwa1EvdFE3cmdkaS9GMlBhWUZpQlIy?=
 =?utf-8?B?ZmduT2Z6eXVhVmR2d2gyTlYvVytGOHgyT2FESzVlOWkrQlNnUXR6NHNEYXFz?=
 =?utf-8?B?WjhXWnFuY25QK3pBL2xWQjE5ejl1SExhZmlXTVNMY1pLRC9sanE3ak1LZW5G?=
 =?utf-8?B?WUdwV2FHOFNLRy9vSlE3ak1jQTBBTEt0RjV6SkRKZU5kOXQwdklzYWdSSURU?=
 =?utf-8?B?WDlxM1VMbHFyZ3dqNmw5a0Z6RGxNNHhzRG83Nlk4NkpqeDFFVE1qaEVqL05Z?=
 =?utf-8?B?bFNxcE1YN0lacWpPRFR6RElKZWRXVkw1aFpsZWpUWTdtNHdZaFYxZERjNWFy?=
 =?utf-8?B?Q1NKczZNVFVPblV4NGxWbTBRUDBaRkFyOTFtcDZUUi9KcmpwYkxlY3QwMXh0?=
 =?utf-8?B?OTIrN3ZVb0xvdzlySzlVVXY3T1QxWUhGekhBUVczR0RnYjQvU3JrUHJEZE01?=
 =?utf-8?B?NVZ0L1VYbGtOeDUzYzBuWjhvWVRzQWdlbytFbkpSajNDOTFudzYvenQ4MVI2?=
 =?utf-8?B?aWpSQU5PeDRqNWI1MWt3UkdTQjFhK0d3WjhVQWJtQTFJMTBVNER3MVVTV3hJ?=
 =?utf-8?B?OTJsRVM0RXJ6aDR4OGRCMnhJMVY2T3JnTkpyQkVNZ3lvOE13UlNqL0EvNDFa?=
 =?utf-8?B?MTl3Zi9uOUtFc0RPMFZ5ZFdDdjVURGZmcmkwREowN3Z0dXRlQ3FzZmZSckU3?=
 =?utf-8?B?Q1lUZzNNSnpSbFV1WStxaEJ0Ym1zdEV2UUxCdnVNU1RCSk1zVFd1RER1N0VY?=
 =?utf-8?Q?DVHUz3WPhraTUHKi7twaq91SICq/BjywN1eaVL0oTKro?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3667.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 373afcb3-885a-4bf9-4c97-08dbef82548d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2023 19:52:04.5983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r1qxmXd/GfcgWlKaej4HgjYBnIqzuhosdi1hd2aKmnrV5uAmBYLiRRDBMoKQ1QsVE8xRlIgJ25fxHUcbriBO5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3802
X-Proofpoint-GUID: bPilfM6UjTHxMyvfV0oH1q7JKU82ats8
X-Proofpoint-ORIG-GUID: bPilfM6UjTHxMyvfV0oH1q7JKU82ats8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-27_18,2023-11-27_01,2023-05-22_02

DQoNCj4gT24gTm92IDIyLCAyMDIzLCBhdCA1OjQy4oCvUE0sIEtlbnQgT3ZlcnN0cmVldCA8a2Vu
dC5vdmVyc3RyZWV0QGxpbnV4LmRldj4gd3JvdGU6DQo+IA0KPiDvu78hLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4g
IFRoaXMgTWVzc2FnZSBJcyBGcm9tIGFuIEV4dGVybmFsIFNlbmRlcg0KPiANCj4gfC0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0hDQo+IA0KPiBJIGp1c3QgZ290IGEgcmVwb3J0IG9mIGRhdGEgYmVpbmcgbWFya2VkIGFzIGlu
Y29tcHJlc3NpYmxlIHdoZW4gd3JpdHRlbg0KPiB3aXRoIHBhcnRpY3VsYXIgYmxvY2tzaXplcy4N
Cg0KSXMgdGhpcyBvbiBsaW51eC1uZXh0PyBJZiBub3QsIHdoaWNoIHJldmlzaW9uPw0KDQo+IElu
dmVzdGlnYXRpbmcgYSBiaXQgZnVydGhlciwgd2hlbiBhdHRlbXB0aW5nIHRvIGNvbXByZXNzID49
IDMyayAob2YgYWxsDQo+IHplcm9lcyksIEkgZ2V0Og0KPiBbICAgIDguMjE0MDkwXSBiY2FjaGVm
cyAodmRiKTogenN0ZCBlcnJvcjogKGVmYXVsdCkgLTY0LCBzcmNfbGVuIDMyNzY4IGRzdF9sZW4g
MzI3NjgNCj4gWyAgICA4LjIxNDcxM10gYmNhY2hlZnMgKHZkYik6IHpzdGQgZXJyb3I6IChlZmF1
bHQpIC02NCwgc3JjX2xlbiA2NTUzNiBkc3RfbGVuIDY1NTM2DQo+IFsgICAgOC4yMTUzNDldIGJj
YWNoZWZzICh2ZGIpOiB6c3RkIGVycm9yOiAoZWZhdWx0KSAtNjQsIHNyY19sZW4gNjU1MzYgZHN0
X2xlbiA2NTUzNg0KPiBbICAgIDguMjE1NDMyXSBiY2FjaGVmcyAodmRiKTogenN0ZCBlcnJvcjog
KGVmYXVsdCkgLTY0LCBzcmNfbGVuIDY1NTM2IGRzdF9sZW4gNjU1MzYNCj4gDQo+IGJjYWNoZWZz
IGNvZGUgdGhhdCBjYWxscyB6c3RkOg0KPiBodHRwczovL2V2aWxwaWVwaXJhdGUub3JnL2dpdC9i
Y2FjaGVmcy5naXQvdHJlZS9mcy9iY2FjaGVmcy9jb21wcmVzcy5jP2g9YmNhY2hlZnMtdGVzdGlu
ZyNuMzUwDQoNCknigJlsbCBsb29rIGludG8gdGhpcyB0b21vcnJvdyB3aGVuIEkgZ2V0IGJhY2sg
dG8gbXkgY29tcHV0ZXIuDQoNCj4gLTY0IGFwcGVhcnMgdG8gYmUgWlNURF9lcnJvcl9tZW1vcnlf
YWxsb2NhdGlvbiwgYnV0IEkgZ2V0IG5vIGhpdHMgZm9yDQo+IHRoYXQgZ3JlcHBpbmcsIHNvIEkn
bSBhIGJpdCBzdHVjay4NCg==
