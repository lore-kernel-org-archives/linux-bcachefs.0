Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="EwUuDlEZ"
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4451AE
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Nov 2023 14:04:06 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 3ASLO6Id006706
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Nov 2023 14:04:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=GK+nZJ29BA7GQlndHJMj5xwWHRdpZeHiF6HUfhDS9CE=;
 b=EwUuDlEZEynb2YKJF45gXGLz0bO3YQXqgTxxZmORVaat8fpleLgwi9vMlv6eyZo0Yy9R
 LDkRcMVam8l/nqEKw5zAenMO4Z3ebfMgVc48j//a3CdZ/L4y5GF3FxgxmJZJGRzheHl2
 v2JSnt6DASPTSjwIp/18myAD0rC5RVCdeXrBg7MwwZflKyWsKZZf3DWx8QdroE8+T7Jw
 I6DCqVMZVsnpKEMUr6gGOEF5D79J3e0p/IlQZXRQrv0Hn+pGHIyvLD9BqN8psuIeM1t9
 hLdnC0qH1jmX4tRzja9CQmzVM77dE5XF0+xPOP6Znfb0+rUeqBdkj56yPoSsSYTa6DNm qw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by m0001303.ppops.net (PPS) with ESMTPS id 3un1wm8wff-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Nov 2023 14:04:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XAxgUxSo2vyAz1dGVKPxtpdhESCzCrK43LO/cgZ+mWrxQ1UUnK0Gn3VZXvXQNKwt5xIwpZIT8E3KMBZx2acEhU1r5hEKCpBjN8uMRZvTTztHkEQADGqln8J8Gsk7W+nSwz1IsUZqaMh4wcxA4ZucpIK/O6BVB77go/ZY3uq3WhdoF+R03454nEhwWFxeow9gLRDlYn70W/To/AMy/v3jGk5xfB82i8E7jnlMa04DoNO1CYWmQ6fzLW13Wg7ImznDcDCgHllXT5OQnPYSUJXxCQHCTlFCvea22LU/1sfVKzEGHmweJHRZDzjIsZhf6/mr0TxiFXV8pD6q54mS6f8H9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GK+nZJ29BA7GQlndHJMj5xwWHRdpZeHiF6HUfhDS9CE=;
 b=AIBjgVNmI8lRpWXKpCeYe1/gK2Zt3sgEN5r3Fml4Hs5ibIPfY85bFY1zfVoEu+ZdU68yL98DZ7qBgtNoK2GdGVVorpEYpzpK3lJuvMS/NcToHbfChPFp6FJW5X1VZRbCch0utkpgtxtLHhgHjTXBcrkX+iYeMBIj98J3EHK3dmmwIDn0tog+noVjSCJXSmOMb+oKr4oK+p/resGRgfkA3OcXvklnp0QcVhT2JLIgumkS34upIBs9JoKKht13Gc+3WI++lV+8r+YBtmnJjBzM6XqbYrdrYQEBRcrY49m1Wx7U4Y/TvpjEeoswAhCShhcr45Hpb93E9P48fEO2OQC8rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BY5PR15MB3667.namprd15.prod.outlook.com (2603:10b6:a03:1f9::18)
 by SA0PR15MB3903.namprd15.prod.outlook.com (2603:10b6:806:8a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.22; Tue, 28 Nov
 2023 22:04:02 +0000
Received: from BY5PR15MB3667.namprd15.prod.outlook.com
 ([fe80::cbea:e86f:62db:9b00]) by BY5PR15MB3667.namprd15.prod.outlook.com
 ([fe80::cbea:e86f:62db:9b00%3]) with mapi id 15.20.7046.015; Tue, 28 Nov 2023
 22:04:02 +0000
From: Nick Terrell <terrelln@meta.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
        Nick
 Terrell <nickrterrell@gmail.com>
Subject: Zstd write past end reproducer
Thread-Topic: Zstd write past end reproducer
Thread-Index: AQHaIkbMXYjMlN3fRE+QNwsvCfOqwg==
Date: Tue, 28 Nov 2023 22:04:02 +0000
Message-ID: <F9E55704-6BF2-4ABD-9DB6-62D908EB97DC@meta.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR15MB3667:EE_|SA0PR15MB3903:EE_
x-ms-office365-filtering-correlation-id: e883a3d1-a19b-48a6-02ce-08dbf05dee91
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 MfS/XfhYWrmNL3UmcjaBZw1gIs2AYlgHu0REYEg9NLLkd5RgxpxvFKggn9cHpBQ57ovTTYyGpps7DesFV8LitQXMcOLJuJOof59Dvm/H7m1bxBS91JJF1t4966qcAPM/O0WGA8VVxiMSNuh9e8poEjb7NmOONx8gedJCm7Il1cdJ7kKoLnj2btQMPHY9J8Mo4UrnJzQNCRmOp2Bw69jkrFRxXbb2izhFsEkFzL3TkYLOrG0qVFlv0m8mcc3z1hfsCU0tXZah49D4zu1RzScbRFT1BgB050pATf3Tg7gvFZny7mjElvB8hwUv9g2WXbIflf0G58iZVm4+DuLvo5EHuhJ4adClgdVz7uwZhZSoQ3oozpHGy/4fcx5ltKujh1MBHc94RQhYWG00KB735IGyHMZJuVp7Jq+lThxcAFDVnWSASqY10v4b0UtjM80nCDdcHJz6KUyqO3yp+/YKsPO3N2ZUmh/d2h9kVgEWHxD54Mhxs6SZBQP2VRW8uBbVp7DalYnSycBitaOLQ63k7UzWZVSvfXFm+fjXN/lmSfGORWRfsbxpNbYeVyk4SlHJpier6i41C1kwU+1UFzYslzxDZ/REfz3DIdJL3QO85K8ZjNoAK7gqYOVBgUyEGpvq3ig6ZJKRav+2RWJs3gnMs6RZjg==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3667.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(136003)(346002)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(36756003)(122000001)(33656002)(83380400001)(38070700009)(54906003)(6512007)(6916009)(316002)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(71200400001)(478600001)(6506007)(6486002)(966005)(5660300002)(2906002)(4326008)(26005)(86362001)(8936002)(8676002)(2616005)(38100700002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?emZTUWNhQjFlelIxTXFMNHlSR0RmUmJKd2l0Q3NxbDNZcXh5MWdMelFrY3Rh?=
 =?utf-8?B?ampOVnVKNlNseTcvT1h5V3BBYXdGOEJuWHEvNXVzNGlZaDFISWRVSy9RZXR5?=
 =?utf-8?B?S1N4NVJ5YXVUUWZXc3JRaEtVMVpwUzQ0RkZPK2NWOWZZV1RKQ3pDUTdHZkk5?=
 =?utf-8?B?bXQ5ZWZUWk0wa1B1ZHFhRHdGMUdJUHdESlhoVDNkWFlwQ0Nha0doUS9mRUZn?=
 =?utf-8?B?S2VaUDBBazlOSjJMQ1BYL2tDY2IzTnM2ZXZrd2RLYXhKVE5wcisvZGVqZE8y?=
 =?utf-8?B?TVFKZkxKd0doaW5uWGN1eDlwc0g5VmRocFlwV24wOVVvNU51NnJ4ZHhCL2xX?=
 =?utf-8?B?ZXBTaGxjakZ3NExHMlg4Mjl3eDY0OWdlWkdJZSswOEw5aktRTkhjdlFuNVA3?=
 =?utf-8?B?NFJnZUp5dmlRbEtoYkZLTFVRT29qVFhzcTd0TG84OVdtUGtJTS9LYlA1Y2V5?=
 =?utf-8?B?MmVSdGJZMmJ6ZDlhbnNSaSswRURWOEtSVGlKUW5rY0t5U2xrcysxVzZ0RWdR?=
 =?utf-8?B?aW9KVC9vamtKYjhXV1lvaGZGYU03V1pZMVkvSmc5eDIzSVh5QytzTG1xdlI3?=
 =?utf-8?B?RGNYYjZFanVEOFhGQUxhSE1EZU55U21hMnJ2MDlKclZVRHl3MXZPZU5QZUFH?=
 =?utf-8?B?UFJVZ1RHdW9mYTdTTUFxWkJHaUJWNWFJZVMzUGQvNnRiNVZEZm1BU3NvVU5P?=
 =?utf-8?B?Z1p3d0I5QWFWZFNSQzBnK0Qvc1F6ekNHN1Q3ZTNFYWRDaE9mdUo4eWJOK212?=
 =?utf-8?B?eHBGTDFOcldZMzdGd3lPd05MMW0vam1VZEJWbjg3NWJ0V0YxQW1nUHlQS0F3?=
 =?utf-8?B?dVJVODR6bFF3c05UZTJtOUx3Nk1JUFYrVFE4eEdQZVZrTXNtVXZFTGl0dTFG?=
 =?utf-8?B?dUZ6MlNoYU1aYXlzcXRxbXh5ODRnVEVvNTBQZ1dPM0luS0h1QU1sZjRzaXBX?=
 =?utf-8?B?UWhLemEzQ2dlSmdEbkJDMGU1bWZSYlFreHBFSWR0SGwySEhYY3NpY3EzY2Fh?=
 =?utf-8?B?K05CRG1WODM4b3dpUktsTENtcEloaWZTK2tTSWN2emNzcVBubHMzY1NsU0hs?=
 =?utf-8?B?NlNjeTV5RmZWNHVoa2swZmNGTlZ0R3ZHZjQ2T2ZhZ0syaElxZEJnN2tSbm9y?=
 =?utf-8?B?aWtkaXhVTVkvOGZyd2FOMTc4SDVFaTZwcGsyeTQ1VGxCSkg4Z0FLNXkwd0F4?=
 =?utf-8?B?akRVZjdpbEh4c0t2ejV3RWJZNm5NTXgvM3BvY056YWcvMkYvRVZxTWJZdUw1?=
 =?utf-8?B?VWxrU3JlUlF2dFc2cndxZUZyQW1PQlBGaEt2YkxiVlY1V1N2SXEwQTdlRFE4?=
 =?utf-8?B?SnZhQjFpekN4a085ZGE3V0NlcE1jaHpGWER4eCs1bXdBMUlrVi92QkJ2Nmkv?=
 =?utf-8?B?Sk5KMGpoOFJwaEdUM1QrQmlUMHU3UlFJY1NHSWROK1Z4b1NLUzlsQnZLOHZk?=
 =?utf-8?B?MkJGUjdGTzEzdms1ZU5sSXZibzA2OFlvVHlqeldVUGtkeFpRR0lQUlNGUFcy?=
 =?utf-8?B?TmJ1OTJvdk1BRndRdEFCWnlMeUZvaStTRFBGMXhKci8xdUNvV3AxcUVEZllC?=
 =?utf-8?B?b2twOXhPV08xdUZsZkF2WGRCQURNcE05UHR1YVpHQk9FMG1IVUUwcEwvdWFC?=
 =?utf-8?B?WDFPNkZvc0x1bVBRUitRTXJLbGpUUzJ3YTBuZ1hVUkdRbCtWZ0NtWG00RnZq?=
 =?utf-8?B?QnZKTThRK001cXNrQXJsY3prVkh4SlErNUdmYm9pNXljUXNHL2x4V1prM1BR?=
 =?utf-8?B?TUFGbXA1QmpYR2taMjBEUVRhYnVLVytZTkFneVRlZ2txK2EwSTJYalMyMnNR?=
 =?utf-8?B?d2FCOTlaSGhUTDJqQlQzRm1LakJTY0ZjZXZHclpXNSt4SHJldUZNSEVNTmVu?=
 =?utf-8?B?d3Rza0dQbk1SSEhXT2NicmtWbk50aENueUpRNjlGOUNSWGJwb1pIaVFYNXZy?=
 =?utf-8?B?SGVMTVBwaDhTazQvbk1lMzFHZTNNWlJCS1ZJeDNMa0JXSWtFeTdWQjlBRlNS?=
 =?utf-8?B?U2lNWWtha0o2ZFJLR0JaZ1NlMU16VVdFY015NFlyVS9QREMzNzRzaEhkQzdi?=
 =?utf-8?B?V0RpZVpKRkVYbE42b2pDQTB0WUluaG10N0NPT2x6UnVvazRTYTgvTGVhMXhK?=
 =?utf-8?Q?2ZetdlxKcpZp8LvPw/l0RKcPi?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F70B040525A3464CB0E79C8D1983AE0A@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3667.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e883a3d1-a19b-48a6-02ce-08dbf05dee91
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 22:04:02.7563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fOysCcQ6qYsnTo+nVRPQ0+J5ANTIHg/wCHom20QeFf3wtsGyeJF8VDeWseEfVv1TYEknEQCCRtiPp3bm17/HjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3903
X-Proofpoint-GUID: vFaciV1vYriIWFYLZqs5zwmSFVzqz8TF
X-Proofpoint-ORIG-GUID: vFaciV1vYriIWFYLZqs5zwmSFVzqz8TF
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-28_24,2023-11-27_01,2023-05-22_02

SGkgS2VudCwNCg0KSSBzZWUgaW4gdGhlIGJjYWNoZWZzIGNvbXByZXNzaW9uIGNvZGUgdGhpcyBj
b21tZW50IFswXToNCg0KCUFkZGl0aW9uYWxseSwgdGhlIFpTVEQgY29kZSBzZWVtcyB0byBoYXZl
IGEgYnVnIHdoZXJlIGl0IHdpbGwNCgl3cml0ZSBqdXN0IHBhc3QgdGhlIGVuZCBvZiB0aGUgYnVm
ZmVyIC0gc28gc3VidHJhY3QgYSBmdWRnZQ0KCWZhY3RvciAoNyBieXRlcykgZnJvbSB0aGUgZHN0
IGJ1ZmZlciBzaXplIHRvIGFjY291bnQgZm9yDQoJdGhhdC4NCg0KVGhpcyBpcyB2ZXJ5IHVuZXhw
ZWN0ZWQsIGFzIHpzdGQgaXMgZXh0ZW5zaXZlbHkgZnV6emVkIGZvciB0aGVzZSB0eXBlcyBvZiBi
dWdzLg0KSXQgZG9lc27igJl0IGxvb2sgbGlrZSBiY2FjaGVmcyBpcyB1c2luZyB6c3RkIGluIGEg
d2F5IHRoYXQgd291bGQgdHJpZ2dlciBhIHVuaXF1ZQ0KY29kZSBwYXRoLCBzbyBteSBmaXJzdCBz
dXNwaWNpb24gaXMgdGhhdCB0aGVyZSBpcyBhIGJ1ZyBpbiB0aGUgd2F5IHRoYXQgYmNhY2hlZnMN
CmlzIGNhbGxpbmcgenN0ZC4NCg0KSSBzcGVudCBzb21lIHRpbWUgdHJ5aW5nIHRvIHJlcHJvZHVj
ZSB0aGUgaXNzdWUgYnkgY2FsbGluZyB6c3RkIGluIHRoZSBzYW1lIHdheQ0KdGhhdCBiY2FjaGVm
cyBjYWxsZWQgenN0ZCB3aGVuIHRoZSB3b3JrYXJvdW5kIHdhcyBsYW5kZWQsIGJ1dCBzbyBmYXIg
aGF2ZW7igJl0DQpiZWVuIHN1Y2Nlc3NmdWwgaW4gdHJpZ2dlcmluZyB0aGUgYnVnLg0KDQpJZiB5
b3UgY2FuIHByb3ZpZGUgYSByZXByb2R1Y2VyLCBJIHdpbGwgbG9vayBpbnRvIHRoZSBpc3N1ZSBm
dXJ0aGVyLiBJZiB5b3UgY2FuDQpwcm92aWRlIHRoZSBpbnB1dCBkYXRhLCB0aGUgc2l6ZSBvZiB0
aGUgb3V0cHV0IGJ1ZmZlciB1c2VkLCBhbmQgdGhlIHBhcmFtZXRlcnMNCnVzZWQgKG9yIHRoZSBs
ZXZlbCAmIGVzdGltYXRlZCBzb3VyY2Ugc2l6ZSB1c2VkIHRvIGRlcml2ZSB0aGUgcGFyYW1ldGVy
cyksIEkNCndpbGwgZGVmaW5pdGVseSBiZSBhYmxlIHRvIGRlYnVnIHRoZSBpc3N1ZSwgYW5kIGdl
dCBpdCBmaXhlZCBpZiBpdCBpcyBhIHByb2JsZW0gd2l0aA0KenN0ZC4NCg0KQmVzdCwNCk5pY2sg
VGVycmVsbA0KDQpbMF0gaHR0cHM6Ly9naXRodWIuY29tL3RvcnZhbGRzL2xpbnV4L2Jsb2IvdjYu
Ny1yYzMvZnMvYmNhY2hlZnMvY29tcHJlc3MuYyNMNTg4
