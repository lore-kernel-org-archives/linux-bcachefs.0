Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Bwa4wcXX"
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6CB1988
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Nov 2023 15:52:02 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ASIYn5a007341
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Nov 2023 15:52:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-id :
 content-type : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=5rppYiepjKVj8gKtbXSEyzaihKKKB329URHt19skS3k=;
 b=Bwa4wcXXGtLcluofGSvMnzkClWjZMhS39c+8dAaTUoHPFaTxBNhFEIf8xRuW3fzw4i8f
 yj04TNF2/ycsDdq7iOUhl+EeeoKLDjeLzes3vihm+/0hG27uGY/OE6G1rA7gTa/Lr/pg
 lIE/9A1bEwNc7U8cbAlFHvEdJy6GxB96ynwdNpzxf6ksoZkPYz7yZRY2RGtxj164gAPE
 AyjivTma1OLqPcksCVSMzstAdGYctS8vUplhyWqubPWpEsoXngMpDezz5OnmIwpRwXsO
 ZyW3+tSNkvqO6hk6izeUjwpZMo7vlt7jRa6W8ugv9fL/xEoByEQtqP7kVoADrtnNnox8 +A== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3unnky20du-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Nov 2023 15:52:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dE1175bNqsuqYov5f3M4w3V0bwkFewNnKxU6waGzY8ZBO7MtV2HowUWh1N9WH8v5K3ma717qmHeLGW+DdYjIouB3EMBufqL9F7qi0aMbrhe7Ja4E7cJSTViMXthXl2AS/OUZpzTE4xWMk4NrrEUWp8ikPACWb3I/lV+Q32Ku1pMBPv9ufs4tCFaisF1vmkWzd/MtcVzwd9DJ2mA5wBKDBWxwKhtlr3FCRXyvoESbyiRYcHX2Cwr3mtEK3QuXXth8D6TxaCwvtYuP7UoC3DPqC7WUcAcdwXs/2VTIrxUeQIiKIfQ1hD37kWFpXMEmmDLMtfj0SM4Zauum1/Xom1ynjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5rppYiepjKVj8gKtbXSEyzaihKKKB329URHt19skS3k=;
 b=ey6WFieJk3QCCTF+l6RMicetc6+2DTbIVFEZ6j3X6UsMTplgZHTs7hyzEO+5OdJVp7mG/bvKL1/Y3mXR5hmLEdhQ4bQeRkpO0cs+AmFWLbmiKBUZRInwA7k0XCh0N9H2gIECq7vsyPfG4YiRlngM/FADscfZqtDN5I5Wv2LxdzuPgFI9tr3OgXZhG7XgLO4xpGb+TH7pRU/V7KC25PXCEP/eL4H2VpwhByr2SOgoTOAW2UDzf3Oo0tDVJKi+58p6ea+hz3zTRJu8PYT1F7euWNe/AfznPTJgmOR3cKQeuiHkOjS9ic8eAYwvGoAknOGxqpfwpoBF1VECa1dURRqGeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from CH2PR15MB3672.namprd15.prod.outlook.com (2603:10b6:610:5::14)
 by DM4PR15MB6012.namprd15.prod.outlook.com (2603:10b6:8:184::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.21; Tue, 28 Nov
 2023 23:51:59 +0000
Received: from CH2PR15MB3672.namprd15.prod.outlook.com
 ([fe80::69fb:5834:35fc:767b]) by CH2PR15MB3672.namprd15.prod.outlook.com
 ([fe80::69fb:5834:35fc:767b%7]) with mapi id 15.20.7046.015; Tue, 28 Nov 2023
 23:51:58 +0000
From: Nick Terrell <terrelln@meta.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
        Nick
 Terrell <nickrterrell@gmail.com>
Subject: Re: Zstd write past end reproducer
Thread-Topic: Zstd write past end reproducer
Thread-Index: AQHaIkbMHABPlreVtU+JBBdPAv0Ea7CQSnCAgAActQA=
Date: Tue, 28 Nov 2023 23:51:58 +0000
Message-ID: <9E69EEFF-73DB-478F-9927-30BF98F08039@meta.com>
References: <F9E55704-6BF2-4ABD-9DB6-62D908EB97DC@meta.com>
 <20231128220903.up7chj4mw5r6glbf@moria.home.lan>
In-Reply-To: <20231128220903.up7chj4mw5r6glbf@moria.home.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR15MB3672:EE_|DM4PR15MB6012:EE_
x-ms-office365-filtering-correlation-id: e82390ee-c551-46cb-64d5-08dbf06d027b
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 kO5WRwZMK4ILDgAML5llfeNFFnxZssFa4BeLOH9U9ioTqSGbchBVI3a0O8jRm0z1FKVTiHwqFHUS+9FWPyIMbn4DClHB4Jd8C3arFS1FNtaLMGUWs77ueX+G6Ohppmd0u/3lx4MvSKh0LoCdBWxAb9Ppfnk7Cp02r35UYAeZ+G+BE5nqKXKEH+nNii4E5LMuhpWb9w+VJUC94zqjIL15Eghcj/NQTSXnpG3Y6kKq3nMbCN2EtkIgZ0oQSsTA1s9r3iOMY5xy41/nDgMj5WrgqN3UrwseNVUVmmlFOuEVU3sai7r3132CF5GipDhwLXU1e9/fD0M9hkBVuIy397YkY/eFXJAb2L2BqtjxY2Rjp5ugEHVe7Nf6Ke5kU9oTMJWCPShsrzZWQ7VSrqPMbTaCzlFx2WuvrwteBlFjcj2ZBOsz+JkENEbI+kccLitA5+2vwYwpMRd5rd8H8NZL5272ahqCAsyjS6LVtjfdqi/iZK8bjwAXctVpVl/a1QIhe/pT39uhfoxc8iGTkYZY/bJsbuFtPc8P3QG50Sve6x6UM+EsQdsMsj+rxJP8nqbr8l85zlYuh80LUXm0DkUVVKNFTkvUgI/KE+oRmw2Ne21jE6MU0D0cF+46DOhafp9uiz3qvqlTAniK6kKoBZ6xDlteWQUKK1i5RUdENCBgmZwuwj9qrFwlJIA5B3i2SuqGhy/y
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3672.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(136003)(39860400002)(396003)(346002)(230922051799003)(230173577357003)(230273577357003)(451199024)(186009)(64100799003)(1800799012)(6486002)(71200400001)(6506007)(478600001)(966005)(2616005)(6512007)(53546011)(38100700002)(38070700009)(36756003)(86362001)(122000001)(33656002)(91956017)(54906003)(5660300002)(76116006)(66946007)(41300700001)(2906002)(83380400001)(8936002)(6916009)(66556008)(66476007)(8676002)(316002)(66446008)(4326008)(64756008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?UW5RMVZlR0t2d1E4YXZhOFFLbzlCR3gzdmtoKzJlWXlIMVpIVi9UU0tmYjUr?=
 =?utf-8?B?Y0k0NEtTMTBURHhqcWx5STZMTHJaaW5BWnluelpwQWxwR1JDUFAycUdGNGdw?=
 =?utf-8?B?WVNrbi9KRC8wcWkyUW1NMDhRZUVTRkpKNlhIR2EwK2lsUDF3c3BMR2dkN1Zh?=
 =?utf-8?B?OWVkR3JVQXNmVWo4V0N1R0tPei85L0xXM0ZLOUM2R0xHTUNYQThRby9NSzY0?=
 =?utf-8?B?Tmw5U2RiWjdpZ2lMeC9EVUJSdGh1TWhDSUF2VXJId3FrMllDd0tkM1BPU2sy?=
 =?utf-8?B?TUxFL2hvUDVhZzN1UUNtNlkvT29LUGc2L2lHRk1LTmplSlJHaS9XU1VIMXF6?=
 =?utf-8?B?Sy83REhQby84V25aSVp0eXkvZ1JSaUFYNHVxZDJOM0hWb2JXaWIwTTNTMWVT?=
 =?utf-8?B?Ylh3R21NbEFiTUNaUjBSVmxkVnJFeHpqRzZyMVlUTnhQY3ZrNVdqUVFIZDdO?=
 =?utf-8?B?cWIzSmNXZ2RMMVlPVjFJelJDVVVuV0pOSVdxaGNtSTl0TlVLeTFSQ2lXVU1X?=
 =?utf-8?B?c0ZWdndWSll4Rk9RT1pLQUluVFFKNSswL0Qwb0RqRzFTVURobEc4MVlNMEht?=
 =?utf-8?B?SmhpcktjWCtyVVZBeEpJL3RFTVZRMUFKYXhWUjBVN0N4c3NnbGp2bXROeWVJ?=
 =?utf-8?B?SThrR3BTaENJWEg1WkFPYWJvV1Y4RW5zZGRSYm4zaVhzalB5dFN4WTBhbnJt?=
 =?utf-8?B?MHkyV2p2dVJYZEdLVnQxTG0ycmFWSUxyNGNrTXBEdk9MUVpkbjdkaG1LVEFv?=
 =?utf-8?B?OXJaMFVCQ2xpM243U0kyTEh4SjZIWWZQQ2J3clNiMlhZVlpxZjRQTjVLRE5N?=
 =?utf-8?B?KzJncVhyYW5KQ2xuWXJYNEM4YUlDSE1RTzhYQmxiTGJvQ0NQc0loalZrS1FK?=
 =?utf-8?B?T0dqUzEybm53YitkY3QrdXZ0dHN5dDRzOVVpTS9rSk4xSnVBUFVQM1NxQXRn?=
 =?utf-8?B?YnRsQnhjOHdQWGRTejhHOWpvcW8xR2Z3amk3S3pRWFJXbWUvS0JxSGNOMkI0?=
 =?utf-8?B?cm5CZHg3Z3NZeDIremtUQmU0eHIvUzFnL3dDVi84T2dOT1AreWpTTHZjcC8z?=
 =?utf-8?B?cHBwNjg3azUrLzhjYncvbVRNbmpFeWNnQVZsVFdabDFxL2x6Q3k3V0xUQkJq?=
 =?utf-8?B?Y3pGQUhOWFZGN2dqc1hEa0RWY0RNa1c5ZGVlRGlnKzF3MTl1SHFNdGV6WEh0?=
 =?utf-8?B?clJOMkt5bUhVcklJUzhFSk9yUWsxWnhGTFM2dUlueTBWbDBZS09QejZoamFT?=
 =?utf-8?B?SXJBb1B4WW13dUh3R0lhdjNFbWJaNmRRZ01Eb3kvMjFKbkJ6SS9nWmpueHR3?=
 =?utf-8?B?d2IvaGxURDhtdnRPRkhITG8yVWM3RjRkVEY4NmpBZkF6QitGOXV6VERIRFkw?=
 =?utf-8?B?RUgyLzMrQ3lwa3puSHFqSDBRYnFGUUthNEdudjA2Uzd2MnV5ZVVBZzFZZGxZ?=
 =?utf-8?B?aGNaVFRITVNnWTRCQWsrYXNHTDZJSWVXa3Myc0l4YTBxeGptWGRyWWVlbmEr?=
 =?utf-8?B?Z1BlRHk1b1VldjRmcWpTVHFRRlVtcGhrc2cyU3V3YkFmRE5POTkrSmpHNVZQ?=
 =?utf-8?B?MWJ0cTNyR3FMeXRzbE55WFNxMW9DaHhQTkZYOW9CQ24vM0drYUx2Y0FzRTBx?=
 =?utf-8?B?Y2F0M1NLQzM0ZTg4OU1XTWZQTytQWFNPZU9uZ094WWc2RGluOFptYjVPeU5U?=
 =?utf-8?B?N1RrcnBBNzBsaXBMV1ZaWkpoeWErOVcvTnlQV2o5cjNpWTNhem1xeVRCOWJ4?=
 =?utf-8?B?Q2c1cTBYb294MHUxYUU3OUc3OVlrdFhneTVyek9RT0wzeUZmMjhmdlpZUkMx?=
 =?utf-8?B?SUlSaUVsdHg1ZUE2WUp5emN0dGN1SDJvL0pJQnhjRENrdDBUSUlKOU9IZXBx?=
 =?utf-8?B?RDB2QUdNSjlJeUxIY0pFUTVOVW1DYlRXMmc4U21xNVY5VVErRG9pZTJXeEY3?=
 =?utf-8?B?ZS9xTTIzbWt0dzl5aUJ2dzJYZ1pQZG8yTnRVa1FOU0dZSTdacWJjZDArYjJZ?=
 =?utf-8?B?K2hPVGQrQXZxbTZ4MFM0c0pRY2hRS0l2L0cxZGp1cUlCalBkNC9ZZjU0UW16?=
 =?utf-8?B?SzVTZ010cWd0Z2FxU09aeHpySWxSYmJvWkJKVUdEWGljZ082OCtKSG9HUXUy?=
 =?utf-8?B?MHpRcU5PaVovVTFHaTk0NFk5Rmc4RGRROHFqS0xGcnRnc3BWMTNZbXB1Qm53?=
 =?utf-8?Q?OJ6zGMlZqMABuS5pvAqS3OU=3D?=
Content-ID: <1C6F5CFDE02C2743BF99F043C2B8F8D4@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3672.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e82390ee-c551-46cb-64d5-08dbf06d027b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 23:51:58.6478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a35f40qcD81kLZp7Q3P/MaLbqP9MGplXsGC5oyrpqdr6v4lVldRGN05oIUFj8WHit/tvsGcL1KJKfllvup0Rmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB6012
X-Proofpoint-ORIG-GUID: IHOVfCp32E1MZRogwcWhS8PihJGfZ7KH
X-Proofpoint-GUID: IHOVfCp32E1MZRogwcWhS8PihJGfZ7KH
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
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-28_25,2023-11-27_01,2023-05-22_02

DQoNCj4gT24gTm92IDI4LCAyMDIzLCBhdCAyOjA5IFBNLCBLZW50IE92ZXJzdHJlZXQgPGtlbnQu
b3ZlcnN0cmVldEBsaW51eC5kZXY+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBUaGlz
IE1lc3NhZ2UgSXMgRnJvbSBhbiBFeHRlcm5hbCBTZW5kZXINCj4gDQo+IHwtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0K
PiANCj4gT24gVHVlLCBOb3YgMjgsIDIwMjMgYXQgMTA6MDQ6MDJQTSArMDAwMCwgTmljayBUZXJy
ZWxsIHdyb3RlOg0KPj4gSGkgS2VudCwNCj4+IA0KPj4gSSBzZWUgaW4gdGhlIGJjYWNoZWZzIGNv
bXByZXNzaW9uIGNvZGUgdGhpcyBjb21tZW50IFswXToNCj4+IA0KPj4gQWRkaXRpb25hbGx5LCB0
aGUgWlNURCBjb2RlIHNlZW1zIHRvIGhhdmUgYSBidWcgd2hlcmUgaXQgd2lsbA0KPj4gd3JpdGUg
anVzdCBwYXN0IHRoZSBlbmQgb2YgdGhlIGJ1ZmZlciAtIHNvIHN1YnRyYWN0IGEgZnVkZ2UNCj4+
IGZhY3RvciAoNyBieXRlcykgZnJvbSB0aGUgZHN0IGJ1ZmZlciBzaXplIHRvIGFjY291bnQgZm9y
DQo+PiB0aGF0Lg0KPj4gDQo+PiBUaGlzIGlzIHZlcnkgdW5leHBlY3RlZCwgYXMgenN0ZCBpcyBl
eHRlbnNpdmVseSBmdXp6ZWQgZm9yIHRoZXNlIHR5cGVzIG9mIGJ1Z3MuDQo+PiBJdCBkb2VzbuKA
mXQgbG9vayBsaWtlIGJjYWNoZWZzIGlzIHVzaW5nIHpzdGQgaW4gYSB3YXkgdGhhdCB3b3VsZCB0
cmlnZ2VyIGEgdW5pcXVlDQo+PiBjb2RlIHBhdGgsIHNvIG15IGZpcnN0IHN1c3BpY2lvbiBpcyB0
aGF0IHRoZXJlIGlzIGEgYnVnIGluIHRoZSB3YXkgdGhhdCBiY2FjaGVmcw0KPj4gaXMgY2FsbGlu
ZyB6c3RkLg0KPj4gDQo+PiBJIHNwZW50IHNvbWUgdGltZSB0cnlpbmcgdG8gcmVwcm9kdWNlIHRo
ZSBpc3N1ZSBieSBjYWxsaW5nIHpzdGQgaW4gdGhlIHNhbWUgd2F5DQo+PiB0aGF0IGJjYWNoZWZz
IGNhbGxlZCB6c3RkIHdoZW4gdGhlIHdvcmthcm91bmQgd2FzIGxhbmRlZCwgYnV0IHNvIGZhciBo
YXZlbuKAmXQNCj4+IGJlZW4gc3VjY2Vzc2Z1bCBpbiB0cmlnZ2VyaW5nIHRoZSBidWcuDQo+PiAN
Cj4+IElmIHlvdSBjYW4gcHJvdmlkZSBhIHJlcHJvZHVjZXIsIEkgd2lsbCBsb29rIGludG8gdGhl
IGlzc3VlIGZ1cnRoZXIuIElmIHlvdSBjYW4NCj4+IHByb3ZpZGUgdGhlIGlucHV0IGRhdGEsIHRo
ZSBzaXplIG9mIHRoZSBvdXRwdXQgYnVmZmVyIHVzZWQsIGFuZCB0aGUgcGFyYW1ldGVycw0KPj4g
dXNlZCAob3IgdGhlIGxldmVsICYgZXN0aW1hdGVkIHNvdXJjZSBzaXplIHVzZWQgdG8gZGVyaXZl
IHRoZSBwYXJhbWV0ZXJzKSwgSQ0KPj4gd2lsbCBkZWZpbml0ZWx5IGJlIGFibGUgdG8gZGVidWcg
dGhlIGlzc3VlLCBhbmQgZ2V0IGl0IGZpeGVkIGlmIGl0IGlzIGEgcHJvYmxlbSB3aXRoDQo+PiB6
c3RkLg0KPj4gDQo+PiBCZXN0LA0KPj4gTmljayBUZXJyZWxsDQo+PiANCj4+IFswXSBodHRwczov
L2dpdGh1Yi5jb20vdG9ydmFsZHMvbGludXgvYmxvYi92Ni43LXJjMy9mcy9iY2FjaGVmcy9jb21w
cmVzcy5jI0w1ODgNCj4gDQo+IFNvcnJ5LCBqdXN0IHNhdyB0aGUgc3ViamVjdCAtIEkgaGF2ZW4n
dCBsb29rZWQgYXQgdGhlIGVuZCBvZiBidWZmZXIgYnVnDQo+IGluIHF1aXRlIGF3aGlsZSwgdGhh
dCB3YXMgbWFueSBrZXJuZWwgcmVsZWFzZXMgYWdvLiBJdCdzIGVudGlyZWx5DQo+IHBvc3NpYmxl
IGl0J3MgYmVlbiBmaXhlZCBzaW5jZSB0aGVuIChidXQgaXQgd2FzIGEgbmFzdHkgc291cmNlIG9m
IG1lbW9yeQ0KPiBjb3JydXB0aW9uIGZvciBhIGdvb2Qgd2hpbGUpLg0KDQpJZiB5b3UgZG8gZXZl
ciBoYXBwZW4gYnkgYSByZXByb2R1Y2VyLCBsZXQgbWUga25vdy4gVGhlIHpzdGQgY29kZSBpbiB0
aGUNCmtlcm5lbCBoYXNu4oCZdCBiZWVuIHNpZ25pZmljYW50bHkgdXBkYXRlZCBzaW5jZSBPY3Rv
YmVyIDIwMjIsIHNvIG5vdGhpbmcgaGFzDQpjaGFuZ2VkIG9uIHRoYXQgc2lkZS4NCg0KSSB3aWxs
IHNwZW5kIGEgYml0IG1vcmUgdGltZSB0cnlpbmcgdG8gcmVwcm9kdWNlIHRoZSBpc3N1ZSwgc2lu
Y2UgYW55IG91dCBvZg0KYm91bmRzIHdyaXRlIGlzIGEgdG9wIHByaW9yaXR5IGlzc3VlIGZvciB1
cywgYnV0IEkgcmVhbGx5IHRoaW5rIHRoZSBpc3N1ZSBpc27igJl0IGluIHpzdGQsDQpzaW5jZSB0
aGlzIGlzIHdpZGVseSB1c2VkIGNvZGUgdGhhdCBpcyBhbHNvIGhlYXZpbHkgZnV6emVkIGZvciB0
aGlzIGV4YWN0IHNjZW5hcmlvLg0KDQo+IEkgbmV2ZXIgaGFkIGEgcmVwcm9kdWNlciBmb3IgaXQs
IG9ubHkgdHJhY2tlZCBpdCBkb3duIHRocm91Z2ggZW5kIHVzZXINCj4gcmVwb3J0cy4NCg0KRG8g
eW91IGhhcHBlbiB0byBoYXZlIGEgbGluayB0byB0aGVzZSByZXBvcnRzPw0KDQpCZXN0LA0KTmlj
ayBUZXJyZWxs
