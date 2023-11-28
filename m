Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="AeZEykfn"
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244D7CC
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Nov 2023 13:37:00 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ASLBTha004096
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Nov 2023 13:36:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-id :
 content-type : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=nN3zWVJjoMoDsR0pFiLWJRtDSk6mIaIxQEJm/eOYQ5k=;
 b=AeZEykfnqs9WaBMCxJAmRS7h3nyCPb10CfFk4dfUfvrhqPirvbKLOoXx7Stsff39RLRi
 ibsbUWSjb6Ku1SBAXhPzgI1zLwicp7N90cowYsfd2yWPcK8Ii3Ai9sDVd+lwTE527iKQ
 3QhNMQ2pNo9SDMOU6GkJtrV/3dLe8+hGdSuHmVboROChR68mVR33LLs6ewUrQ0jBknXe
 F8S14gf8H4wgomm6BWxtXzETwdbztyWTuGwx7uU4NbugGti6JdfE8RgJxAjtkZIhuBAA
 +uJ9mxIZ/2S5UMMgONGWwHDK7gPVkn+82JlEgp4RPT8EEBzYpD3LBGbZU8/xFtcjdN6t SA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3unjktar85-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Nov 2023 13:36:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzQnO5a8MGl2t7Yer+apiHolR8cYqPXxJU83oTB/7ucV3WU0aSwj8nJoVBpTXPJHS5lJXKpalSA8lnGz+21C6PlG0VIQVWN/agRjlia5Rw6wfysreekNKgUCoApLXmkxmlDCeU/yogvYso3UbkFNYkof/IiJ3xWJEJVlpTjJseSatPgxwLVMWeFmCL43cqWOqPiuHrAoQqSJU0TNncJ3OMegreAyLjwKyz9ZAKT02+wmjetTYTGm0vdGBWpKEIg9HBoxI2difAC80xN2QhUv0QWzjJvHcKM+W2IdhcQCU59jdBrRJxlr6k+L+FFDBVNwMP3pz5aJX5iKWSI81/MP4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SmIDWq32v7cTOVPiCsGATYO42cV7l1bfBVS1Exktgr4=;
 b=gnMufMPQlMKLPR83zE48ZZi+ioSf7vjQKeG23ii/aIWuySIEumb7htTIxwSUX1FR8d+P6mSpv0BICqQAM/2ayNWqfFduk9xoiHSTgr+JO7QjGSBi9urWEPDCNAUzttnyi7KSUJYt5gBoroxFpaXaokgnfMqgoQGmWyGVglfowPLr5QL8jv6OFXSAtj/YrLuwprpzGQwA6e9l9NjUOAiTKb+18O5mvzqveIR7VABd/epYAcs63JixV7F/437sV04iK2JKCI0J4a6OdESBk/GW6UGLJwqAt6T0lzsumZPCTOsrlF+dzU7BIjBsvJqherF4dgpqclPxCwke0B6SHwEXHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BY5PR15MB3667.namprd15.prod.outlook.com (2603:10b6:a03:1f9::18)
 by SA1PR15MB4515.namprd15.prod.outlook.com (2603:10b6:806:19a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.21; Tue, 28 Nov
 2023 21:36:56 +0000
Received: from BY5PR15MB3667.namprd15.prod.outlook.com
 ([fe80::cbea:e86f:62db:9b00]) by BY5PR15MB3667.namprd15.prod.outlook.com
 ([fe80::cbea:e86f:62db:9b00%3]) with mapi id 15.20.7046.015; Tue, 28 Nov 2023
 21:36:56 +0000
From: Nick Terrell <terrelln@meta.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
        Nick
 Terrell <nickrterrell@gmail.com>
Subject: Re: zstd error when used in bcachefs
Thread-Topic: zstd error when used in bcachefs
Thread-Index: AQHaHZUnQFf3VsiQEUO+8ekDfvFcSbCOmznagABr7ACAAUOogA==
Date: Tue, 28 Nov 2023 21:36:56 +0000
Message-ID: <31B4E7FB-A79A-4FEB-BB75-37FE54D83636@meta.com>
References: <20231122224208.procyauioksotuit@moria.home.lan>
 <93FB4B05-7C53-4771-A4CF-1D21AB837726@meta.com>
 <20231128021820.bc4ec62ynhtbtihh@moria.home.lan>
In-Reply-To: <20231128021820.bc4ec62ynhtbtihh@moria.home.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR15MB3667:EE_|SA1PR15MB4515:EE_
x-ms-office365-filtering-correlation-id: d0ef1816-6ac1-4cb2-3ca6-08dbf05a2510
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 XY1TNA1vLigaUlMXWceIkUTiREnDPqFjznzgIDkF7gBOwYFr7MJnVYPh4gJLhuTEBCnVsuqTrb2Eaj/pOoGf5UFh/wa6VfYoTogufJdWlmmGi5eYdzem62zVWGRuyZ+CIhEsoretLHAyp2iW8ieoGn8ml78FbrZ8E4w3g3cit+PFcasY4MKvitFK4YdYCODSYbMLfhfASoE8CWht1i8HBWvdl74jJKhHaSz8taFvp+rCrWCqj+Spg/Z6nL1aDoP00SLUfgskeCN34TugXFK7q1HUquPiA9SIT7b8wI0N0RhWSFeomshrWzFDf8kVRDQFXHM+GGh/8hfjfl8g/fKCqsgj6CXIVIEcIgyvcUirfiSC8agIB5E8Qqlij/JAD6oloIYS/mnJ+EJ41qE73zUri8xKL4yDpJYwqVeQs50N1krvJ/W3Vj6qDiWnzeaJVVfQRiULAu0bgBkw5WeVKudcXjlU+whAkNBIKFtZaZfHoNtvbRO2To9tV8bSXXV5b/pCxNL/daWPe3K7pn8lJGJ3Eo/1+4nGjvIi0vH0VT75yPTRmTUOZIYNrJWYIZUCoas2hqQ2f0cji31yimsTChLmdzqCvmnPZcezWuzdOPsWivhZVhh4YzdEj3sGwH+Htg68ezHMarcswVTuVzk/9fzfkCt59CcPemduBEJQYtjxjbw=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3667.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(39860400002)(396003)(136003)(376002)(230922051799003)(230273577357003)(230173577357003)(64100799003)(186009)(1800799012)(451199024)(478600001)(966005)(6486002)(5660300002)(2906002)(71200400001)(54906003)(66946007)(316002)(66476007)(6916009)(66446008)(76116006)(64756008)(66556008)(4326008)(8936002)(8676002)(41300700001)(86362001)(33656002)(38070700009)(38100700002)(122000001)(36756003)(26005)(6506007)(53546011)(83380400001)(6512007)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?dG5yRXJENXd2MmpvL0hWRlZTYWN1ZU1UVno3aGxrTmFGV1FoUXhxb0NIdEJV?=
 =?utf-8?B?RUZ3bGN1YlR2bEVGL21Cd3V5MGt4Q1JrbnJDTURnQStrVEF3cXlENlF3NHl2?=
 =?utf-8?B?YXNZTmIrSUlta2M1TDN1Q0Z2UjdUY3BXTDRCR2tYbnZTTmxFOXhUbFB5WWNp?=
 =?utf-8?B?YXgvUzJReHFRVHdid2lMbDhHb05PcVQ2THVhb0FpZVRNaTBnY1FVeHZmMmUz?=
 =?utf-8?B?SXJEWTVzcGJodnRaZE9zNThTZnBZV1BwdCszRWlJME9tTm9zRW50YzlWRmQx?=
 =?utf-8?B?dXZIeGN5dXZvQnY0SXhKaXhyeXNQMjhKMkM5UmZqc0pWZ3R4a1ZMa29Qck04?=
 =?utf-8?B?Z1c0UThLczVuK1U4SnRrMjNtTGc3ZWJ1VEowajVuRFdTOTNOVU1IWEE5RG9p?=
 =?utf-8?B?Tk5CT1ZKeGV2OThKL3ZjaEhkLy9kZzlyNUtjV1dzb2hOV0JvTEVHSmprQjYy?=
 =?utf-8?B?cTZrZldPc3pQSXoxK0tRL1NPbVhDOC8wZHZjMmY2dHc1d21VLy9VT1VOcVB5?=
 =?utf-8?B?RGhvdzFzNFJaYXJQN3NHR3d6WUd5UDE5cEhIaXArNW9IbHdMQ3JicXhtcmdX?=
 =?utf-8?B?dG9RNnErNGUwd2VRUnNib3l4SzdKSVFDa3pTZXU4N3B5dWpybHptTEgySU12?=
 =?utf-8?B?NkV4WGRJUjEveGFFT1pjK045TzFPKzZuVGJLVUVWSHpYT2pQWUFjYUdyaG1i?=
 =?utf-8?B?ZkJOZzQxN29lOXQxNGFTbFFjVktISUhZWjlFQThqSjFaTTcrN013OXdndUUr?=
 =?utf-8?B?bzUzQTNlOWJBTXlsYVFVMDdWN0xNRVM1US9lMXk4cnZySVR6dU41aFJnK0lG?=
 =?utf-8?B?MkNTZHpOZDBqTFRPWFJFOEd5eG16L3IvUWh2S01XR1lFSmVaSUFMV01qc0VB?=
 =?utf-8?B?ZXB0RENGZ0lzRDJWTTJDakl5S0p0K2lpVXl1MkJNcEZoQ09VdnJWNHVvNy9o?=
 =?utf-8?B?V0Q4cVpVVHNoRy9VUUwzd085MFlKOFJLN1VNL0V4OExCOG53QnVCM2UvOGxY?=
 =?utf-8?B?U0dLQjJXTzVWQWRmdlZFRWtUNXQwZ2J6UUFWUG0xK2dycWpxQVBsWGg5MTg0?=
 =?utf-8?B?V2FlOGRxNmp5cXdPQXNFR09LZEh3NjVsLzd2NVFZaURtR3RiWTNoR2xTL1hX?=
 =?utf-8?B?bnVuY1EvSWcvdkd0dU03cWwyclJjOXhkNkh5NzNDbHpEdjhEaDN3WmljRGdt?=
 =?utf-8?B?dUE2R3ZEZ0pPNUQ3NVBUQ3hwa1FNVC82YmZNUzRGWlpNellBN21LVk03WUlU?=
 =?utf-8?B?N0tEaVRUbm5RTTk0ZUIxdENvOGc3bjdjNE4vVDhyKys2ZXlxV1FrN29XRVI5?=
 =?utf-8?B?QkhVUjVjbldMOGtZL01tdjErcnF1cUpFb3UxQUZ6VXVFMm8rcy94TUluZHdy?=
 =?utf-8?B?cjczK3YwdmMweUZGQjJ6TXNFR0NiYitDVE5iZzJQd3VFYjNJRWFnako0b21K?=
 =?utf-8?B?eEd0aGM2N2pPWHdTS2NPVDd6TzZwZldiZExSMk9xMXpSMkg4U1lhdU5VdENy?=
 =?utf-8?B?eTdQK3BNeGhrRHRiMnFBUlpqRmFkM1p6c2lRakRuTm9JWTVqbWRYMm1tT2VP?=
 =?utf-8?B?RlR1YTZDWTFUUjF2SUFKSWVSOS8vMHRDU2F4dUVOYmlYSnJCUWFiUlNVVUZ1?=
 =?utf-8?B?RktxcXN6N3dGck9CcEo2YzJVQVN1U2diQmhvcEhjMURmVUZZZ1c1V0hJM3RT?=
 =?utf-8?B?NHpCOWt5ZldiaVVrWTA1a0puUzJ6TjFmU3RKS0t0ZGJ1YitZY0xIT3RQdjBp?=
 =?utf-8?B?ZFVhZlhaaDF6V2VJQTA0aHBGS3lqR282WXhJVlptN3Ixb3M1UUFrYkUvTnNv?=
 =?utf-8?B?NmY5QmlSZHJ6MzBzVHlHelNxQVc2enZnWlN0RVRDSDJYTVU3L2VRQVpQa3Zw?=
 =?utf-8?B?SENvWGx0d0pnZ1krWCtXYmhIUURhN3VTdzI1eDB5YSswdGMrRXp2RWhjMWpD?=
 =?utf-8?B?eFo5dUFJS2phNktKeUZDRVo2NkU4aFo5emJMaDNRbnNvdHowNFNnSXIzYnY3?=
 =?utf-8?B?N2x2Vjl4MmZpMUtkeGYzR0ZsYW9ucno2S2ZTdE00YWI5azZjTE9xSjdSZ09C?=
 =?utf-8?B?cTR5c3pKenh1bFlYNk9QV1NqYittam9QQnkrcXZQWlk5K05LaVF3emtaVVVu?=
 =?utf-8?Q?MQeM6FezzCtKZJKCDwfNTkdwH?=
Content-ID: <4850002203CA8E4B83BBC5FE6EFD2C27@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3667.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ef1816-6ac1-4cb2-3ca6-08dbf05a2510
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 21:36:56.2171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dDcT38WP5oGGrNSvD+p9sv3a3pSkYg0v16zpxOYCNEXAWQ58bEf5qLcjyFyqpKR23myr9n9PNo0OsAWUiJnCjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4515
X-Proofpoint-GUID: 4M9jAfKYGVNLyOJT7-BtmGNkRpzlJO77
X-Proofpoint-ORIG-GUID: 4M9jAfKYGVNLyOJT7-BtmGNkRpzlJO77
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-28_24,2023-11-27_01,2023-05-22_02

DQoNCj4gT24gTm92IDI3LCAyMDIzLCBhdCA2OjE4IFBNLCBLZW50IE92ZXJzdHJlZXQgPGtlbnQu
b3ZlcnN0cmVldEBsaW51eC5kZXY+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBUaGlz
IE1lc3NhZ2UgSXMgRnJvbSBhbiBFeHRlcm5hbCBTZW5kZXINCj4gDQo+IHwtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0K
PiANCj4gT24gTW9uLCBOb3YgMjcsIDIwMjMgYXQgMDc6NTI6MDRQTSArMDAwMCwgTmljayBUZXJy
ZWxsIHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBOb3YgMjIsIDIwMjMsIGF0IDU6NDLigK9QTSwg
S2VudCBPdmVyc3RyZWV0IDxrZW50Lm92ZXJzdHJlZXRAbGludXguZGV2PiB3cm90ZToNCj4+PiAN
Cj4+PiDvu78hLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4+PiBUaGlzIE1lc3NhZ2UgSXMgRnJvbSBhbiBFeHRlcm5h
bCBTZW5kZXINCj4+PiANCj4+PiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4+PiANCj4+PiBJIGp1c3QgZ290IGEg
cmVwb3J0IG9mIGRhdGEgYmVpbmcgbWFya2VkIGFzIGluY29tcHJlc3NpYmxlIHdoZW4gd3JpdHRl
bg0KPj4+IHdpdGggcGFydGljdWxhciBibG9ja3NpemVzLg0KPj4gDQo+PiBJcyB0aGlzIG9uIGxp
bnV4LW5leHQ/IElmIG5vdCwgd2hpY2ggcmV2aXNpb24/DQo+PiANCj4+PiBJbnZlc3RpZ2F0aW5n
IGEgYml0IGZ1cnRoZXIsIHdoZW4gYXR0ZW1wdGluZyB0byBjb21wcmVzcyA+PSAzMmsgKG9mIGFs
bA0KPj4+IHplcm9lcyksIEkgZ2V0Og0KPj4+IFsgICAgOC4yMTQwOTBdIGJjYWNoZWZzICh2ZGIp
OiB6c3RkIGVycm9yOiAoZWZhdWx0KSAtNjQsIHNyY19sZW4gMzI3NjggZHN0X2xlbiAzMjc2OA0K
Pj4+IFsgICAgOC4yMTQ3MTNdIGJjYWNoZWZzICh2ZGIpOiB6c3RkIGVycm9yOiAoZWZhdWx0KSAt
NjQsIHNyY19sZW4gNjU1MzYgZHN0X2xlbiA2NTUzNg0KPj4+IFsgICAgOC4yMTUzNDldIGJjYWNo
ZWZzICh2ZGIpOiB6c3RkIGVycm9yOiAoZWZhdWx0KSAtNjQsIHNyY19sZW4gNjU1MzYgZHN0X2xl
biA2NTUzNg0KPj4+IFsgICAgOC4yMTU0MzJdIGJjYWNoZWZzICh2ZGIpOiB6c3RkIGVycm9yOiAo
ZWZhdWx0KSAtNjQsIHNyY19sZW4gNjU1MzYgZHN0X2xlbiA2NTUzNg0KPj4+IA0KPj4+IGJjYWNo
ZWZzIGNvZGUgdGhhdCBjYWxscyB6c3RkOg0KPj4+IGh0dHBzOi8vZXZpbHBpZXBpcmF0ZS5vcmcv
Z2l0L2JjYWNoZWZzLmdpdC90cmVlL2ZzL2JjYWNoZWZzL2NvbXByZXNzLmM/aD1iY2FjaGVmcy10
ZXN0aW5nI24zNTAgDQo+PiANCj4+IEnigJlsbCBsb29rIGludG8gdGhpcyB0b21vcnJvdyB3aGVu
IEkgZ2V0IGJhY2sgdG8gbXkgY29tcHV0ZXIuDQo+PiANCj4+PiAtNjQgYXBwZWFycyB0byBiZSBa
U1REX2Vycm9yX21lbW9yeV9hbGxvY2F0aW9uLCBidXQgSSBnZXQgbm8gaGl0cyBmb3INCj4+PiB0
aGF0IGdyZXBwaW5nLCBzbyBJJ20gYSBiaXQgc3R1Y2suDQo+IA0KPiBJdCBhcHBlYXJzIHRoYXQg
dGhlIHdvcmtzcGFjZSBzaXplIGdpdmVuIGJ5IHpzdGRfY2N0eF93b3Jrc3BhY2VfYm91bmQoKQ0K
PiBpcyB3cm9uZyAtIGlmIEkgZG91YmxlIHRoZSB3b3Jrc3BhY2Ugc2l6ZSBpdCB3b3Jrcy4NCj4g
DQo+IEkgdHJhY2VkIGl0IHRvIHRoZSB3b3Jrc3BhY2VUb29TbWFsbCBjaGVjayBpbiB6c3RkX2Nv
bXByZXNzLmMuDQoNCkhpIEtlbnQsDQoNCkl0IGxvb2tzIGxpa2UgdGhlcmUgd2FzIGEgYnVnIGlu
IGhvdyBiY2FjaGVmcyBjYWxsZWQgenN0ZCB0aGF0IHRyaWdnZXJlZCB0aGlzIGVycm9yLg0KSeKA
mW0gbG9va2luZyBhdCB0aGUgY29kZSBhdCB0aGUgdGFnIHY2LjctcmMzLg0KDQpJbiB0aGUgZnVu
Y3Rpb24gX19iY2gyX2ZzX2NvbXByZXNzX2luaXQgSSBzZWUgdGhpcyBbMF06DQoNCglaU1REX3Bh
cmFtZXRlcnMgcGFyYW1zID0genN0ZF9nZXRfcGFyYW1zKHpzdGRfbWF4X2NsZXZlbCgpLCBjLT5v
cHRzLmVuY29kZWRfZXh0ZW50X21heCk7DQoJLy8g4oCmDQoJYy0+enN0ZF9wYXJhbXMgPSBwYXJh
bXM7DQoNClRoZW4gbGF0ZXIgaW4gYXR0ZW1wdF9jb21wcmVzcyBJIHNlZSB0aGlzIFsxXToNCg0K
CXVuc2lnbmVkIGxldmVsID0gbWluKChjb21wcmVzc2lvbi5sZXZlbCAqIDMpIC8gMiwgenN0ZF9t
YXhfY2xldmVsKCkpOw0KCVpTVERfcGFyYW1ldGVycyBwYXJhbXMgPSB6c3RkX2dldF9wYXJhbXMo
bGV2ZWwsIGMtPm9wdHMuZW5jb2RlZF9leHRlbnRfbWF4KTsNCglaU1REX0NDdHggKmN0eCA9IHpz
dGRfaW5pdF9jY3R4KHdvcmtzcGFjZSwgenN0ZF9jY3R4X3dvcmtzcGFjZV9ib3VuZCgmcGFyYW1z
LmNQYXJhbXMpKTsNCglzaXplX3QgbGVuID0genN0ZF9jb21wcmVzc19jY3R4KGN0eCwgZHN0ICsg
NCwgZHN0X2xlbiAtIDQgLSA3LCBzcmMsIHNyY19sZW4sICZjLT56c3RkX3BhcmFtcyk7DQoNClRo
ZSB3b3Jrc3BhY2UgaXMgaW5pdGlhbGl6ZWQgY29ycmVjdGx5LCBpbiB0aGF0IGl0IGlzIHNpemVk
IGZvciB0aGUgbWF4aW11bSBwb3NzaWJsZSBsZXZlbC4NCkhvd2V2ZXIsIHpzdGRfaW5pdF9jY3R4
KCkgaXMgY2FsbGVkIHdpdGggYSB3b3Jrc3BhY2UgdGhhdCBpcyBzaXplZCB1c2luZyB0aGUgbGV2
ZWwgY2hvc2VuIGJ5DQpjb21wcmVzc2lvbi5sZXZlbCwgc28gSXQgb25seSBiZWxpZXZlcyB0aGF0
IGl0IGhhcyB0aGF0IG11Y2ggbWVtb3J5IGF2YWlsYWJsZS4gVGhlbg0KenN0ZF9jb21wcmVzc19j
Y3R4IGlzIGNhbGxlZCB3aXRoICZjLT56c3RkX3BhcmFtcywgd2hpY2ggYXJlIHRoZSBwYXJhbXMg
Zm9yIHRoZSBtYXhpbXVtDQpsZXZlbCwgd2hpY2ggbmVlZHMgbW9yZSBtZW1vcnkgdGhhbiBac3Rk
IHdhcyB0b2xkIGlzIGF2YWlsYWJsZS4NCg0KVGhlIGZpeCBpcyB0byBjYWxsIHpzdGRfY29tcHJl
c3NfY2N0eCB3aXRoICZwYXJhbXMgaW5zdGVhZCBvZiAmYy0+enN0ZF9wYXJhbXMuIFlvdSBzaG91
bGRu4oCZdCBuZWVkDQp0byBzdG9yZSB0aGUgenN0ZF9wYXJhbXMgaW4gdGhlIGJjaF9mcyBzdHJ1
Y3QgYWZ0ZXIgdGhhdC4NCg0KQmVzdCwNCk5pY2sgVGVycmVsbA0KDQpbMF0gaHR0cHM6Ly9naXRo
dWIuY29tL3RvcnZhbGRzL2xpbnV4L2Jsb2IvdjYuNy1yYzMvZnMvYmNhY2hlZnMvY29tcHJlc3Mu
YyNMNTczLUw1OTMNClsxXSBodHRwczovL2dpdGh1Yi5jb20vdG9ydmFsZHMvbGludXgvYmxvYi92
Ni43LXJjMy9mcy9iY2FjaGVmcy9jb21wcmVzcy5jI0wzNTAtTDM3NA==
