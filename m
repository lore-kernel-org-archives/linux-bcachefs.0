Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11021123.outbound.protection.outlook.com [52.101.57.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABBD25D21B
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Jun 2025 16:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750003933; cv=fail; b=X360+gLs8bGz8rZhu3Cv329j3G95VGE0X5RtjIyGxNYd80MiTGd6dtVmsm6rmHhL7iYzwfX/dnpsaRPdA+uEeHKLAYyPYNoMfN8Q09UBcMH6APtCdhS0l/kWYgnE82kYnqoudy2Aa8MJnx1eGHlC1Y82QpO0NG6Eap3xCk1iiU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750003933; c=relaxed/simple;
	bh=Si8YzQF0rR7y2uopO7WOS72ve+cax2+ROplc0u6INZk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o7U/difyYghTPLLi/ctxY/eGEiN+UjQq+p9TckCfFiudFOsfJ+6gRef6285ZgUzeS8HrLNARuxHXryolpXorRNhv4YP5UsfENJ50ypcN/L0XYHVH8bVRrP5vbJWwFXgS4djnHhn3Y/RGTx359GE/+Lp6Dy1dOosH1o0q5x60pkQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaronfriel.com; spf=pass smtp.mailfrom=aaronfriel.com; dkim=pass (1024-bit key) header.d=FRIELTEK.onmicrosoft.com header.i=@FRIELTEK.onmicrosoft.com header.b=S4sm0K7D; arc=fail smtp.client-ip=52.101.57.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaronfriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaronfriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=FRIELTEK.onmicrosoft.com header.i=@FRIELTEK.onmicrosoft.com header.b="S4sm0K7D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ErvfW6upnLc6u1+xDuMQQEXKhJKuo74Iz3mZA3GO9bYYx1cJhlLSA3yuglMhb2IYc3j0zLWc9e9vEi2OPc1VwJYnPIovYVE+wt0NnTja1Ou3nqzrGtX6i/u/7xqpjh43ClamQvfKO7nNl6tdTltPAnlFjtK8GajOCcIfvuX+1EnGipmddM/WEpKSiCy2yymD4twjoOg0pK3HH1imHwSQb59TYuni5C2Y3BprWtm5Gdbw8i55beOTQwKzYXyR11D9ptqgT3FP/+fixss2O+LR5O6/1+ljHDtAKmNzNPfCLvcwQIkKA3tAWUX/s2Fu1RycEquAXjsKHT3SUyRZuTpyjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Si8YzQF0rR7y2uopO7WOS72ve+cax2+ROplc0u6INZk=;
 b=Won5+u9F+ReGBFSL4aTsH1EB5GOshl8mS16X2PZ89fdChVYYBBVo2Zw4t4w6zYgP0MG0FXmwptVxLJA++GW0tc//88a4YFlK0oL0+ONoeF3AO1CW7m/DXNgbEF16g8zCwMJ3cxtwtvvxlrPkyMR5pZ5bt6+mDQ+sCNhtaxTeKXf/yP+37dPECwnPahhCw4AjW4X+QvoPPjONBIkcR6SL22+YWHj0lJbfSJm9a8IdEK8yt3TOq8DLLEDX3u/K7QBy4t6izMrzIx0b8ey+sXsdkTUWUXtYOcZEZw2MHpxf+IO3KIbVuPfglUM0J4x5OCPm4k8gC1oNGwMvqB23SBqlbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aaronfriel.com; dmarc=pass action=none
 header.from=aaronfriel.com; dkim=pass header.d=aaronfriel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=FRIELTEK.onmicrosoft.com; s=selector2-FRIELTEK-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Si8YzQF0rR7y2uopO7WOS72ve+cax2+ROplc0u6INZk=;
 b=S4sm0K7DRslM9L61mHPInKAprQW/z+kmj2wSPn9T2njAS3YIUJ75A+U6SM6zRSowcqzFtRddLM8c6QQS/1D4EoB+RTxwr0yIhZrTQmpu9PwC86BGg8OXcv85oxohTDf7UOgvICruCr/3hsdGL8QRa36/qcZabpDj3KKfu599dsw=
Received: from MW4PR05MB9993.namprd05.prod.outlook.com (2603:10b6:303:1ef::21)
 by SA1PR05MB8568.namprd05.prod.outlook.com (2603:10b6:806:1df::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Sun, 15 Jun
 2025 16:12:07 +0000
Received: from MW4PR05MB9993.namprd05.prod.outlook.com
 ([fe80::da:f56d:ad76:326e]) by MW4PR05MB9993.namprd05.prod.outlook.com
 ([fe80::da:f56d:ad76:326e%4]) with mapi id 15.20.8835.027; Sun, 15 Jun 2025
 16:12:07 +0000
From: Aaron Friel <mayreply@aaronfriel.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Issues setting durability on new devices in bcachefs
Thread-Topic: Issues setting durability on new devices in bcachefs
Thread-Index: AQHb3aG7BcdLvKRiWEq49GHsrqA8x7QDmi8AgAAgvtqAAHI6AIAAMKqH
Date: Sun, 15 Jun 2025 16:12:07 +0000
Message-ID:
 <MW4PR05MB9993E5730DFC5449D826473BB571A@MW4PR05MB9993.namprd05.prod.outlook.com>
References:
 <MW4PR05MB99934C43FB32313C921D7765B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <qj5wzirldvxhd6om54mnzenq52hdh25zbvzhtirdgumo4zwh5o@hwccwflcdvyo>
 <MW4PR05MB9993BFE56AEF738F894D5586B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <yfxm2uhmxqavi5p5q5l5hbcn5sgrl7tviccclav2qr65muvd4u@jawmmtvgljsd>
In-Reply-To: <yfxm2uhmxqavi5p5q5l5hbcn5sgrl7tviccclav2qr65muvd4u@jawmmtvgljsd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aaronfriel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR05MB9993:EE_|SA1PR05MB8568:EE_
x-ms-office365-filtering-correlation-id: 9fdcfbe7-4d00-4b99-0fa3-08ddac276002
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TXZ4c2U2WEdsSmFNNHU2c2c2OTlPQUE3UGZkY2wvZHkyQzIrZlZZYnlDODM3?=
 =?utf-8?B?dHVseG9HTnRVUjVMYVRwUnVEbEpDY20reFRDQWEvdEFBRmhpcS93ajNyTTU5?=
 =?utf-8?B?OWV6Z2dQNW92VDd5MmtpdTBnVXpLVWQvdGZYUFd1R212MURuZC95WmV2VXAx?=
 =?utf-8?B?QTltUXZUUmJUbXpVMURhYkgxUVNXOVpkcU55VEFwVmJMS0NFbFV5eVBodVU5?=
 =?utf-8?B?dEtZU21uWTV2K2RJdU01Q2VNWDFjR3p4V1RYcXJHS2FnaGVFdUFHOElCUkV2?=
 =?utf-8?B?NFR6cGwxb2JJdG1abXQ3WlcvUFp3eVFMZWtLSGg5US9rai9QcisxdWxtOGg1?=
 =?utf-8?B?YW5wSlNqVnJJSW5tZVRzTlBsdEtXTk5Ma1dpSmdGaTM3TGs2Z2dOTmFUUDlq?=
 =?utf-8?B?Z1k4alJFdUdWdk5wQ1IyemUvOHROOTB5R2RyVzc2WUJ6cnJVRVJ3WENlR3Q0?=
 =?utf-8?B?ZVBoM2ZvUUhIUFIvelIvOUNVc1N4eEZIazlOSVVIRTQrbEdnblVjSkF2MkRB?=
 =?utf-8?B?aTRGMGF0NHNkeENUK3RoanN2SW5aUFJQbWFmUnhaN3dabGFzMk5BZjR2elov?=
 =?utf-8?B?MGI4dGFJaDIyRkhKWWNlL0dtWWQ3ZDl0MklBa1o5UkZzbWhIclRSTW9DSU03?=
 =?utf-8?B?RnZRb1RFUUNwR3lUOTFnb2JaMGxUemh3aUs0dVNIcldxdnpLNko4bGg3OE16?=
 =?utf-8?B?RkZ3Q1FVcUtKRUxDMlUvVEd2Z0hHUCsydDUyZmpnTk1GWTlDM29uQlp6L1BH?=
 =?utf-8?B?d0dCMWxONk9VZDhzNVZiV3VxbGJaamVoRGNES2NrUGJhUWk5aHR2YXhkdGFi?=
 =?utf-8?B?U09FR3p4TTJLSEp1UXNCY3N6ZUtwRVRjdzJZYTE4Sy9HTE0ycjFQN1Fub3BN?=
 =?utf-8?B?R0RUd1NVTStGQ0l6Q2JWK2NVdUg0UE9pbmZHR284VUVUR2pseEd2V0NiRjVn?=
 =?utf-8?B?UW9YTzBQOERlK2R0STFzc0toM2diNTEvNEdYUGhobHVUdkNnY1c3N2NMUERa?=
 =?utf-8?B?VXloYW1FbjJnUEJ3ZTVtdlVTK1htUFR5bDZGOFozQzlBcUp5ZFlOZW1ZcVNh?=
 =?utf-8?B?azZmcHdiSldMNFdtcFF3U2ZKRndmeDgyYW5UdEJ4U3AwdnU4cmFOM2h6MFp4?=
 =?utf-8?B?ZzlwQ3d2RmVieWk3Q1dsaTIzdlJ5SkFGNTlmUnhMWkhjM2Z3QWpHNEtJMGxi?=
 =?utf-8?B?bXUweko2T25nR2ZvVUdGNk9LUGNPSVhUdTJ3S0U2Nm92WEc0QytrYzl0aW5j?=
 =?utf-8?B?QjJDOGpRQ3hBNDNoaGNZdHZreEdtcEIxcWZRZElYZjFNTkd3cmxXTGcwQUFs?=
 =?utf-8?B?cTVuL1R5Vk1oYWVEQVR0VGxWU1lJY2Z4MUZ4akZqRHN6NEFDZ0Y1QjM5SlNi?=
 =?utf-8?B?NUc5UXU2Ti9IdEs5c3k1TlA3YWFzR1lWd1N1N2RCM0Y1TU1aTGZCV2hUcyt2?=
 =?utf-8?B?UDJKbmdsYldaYThZbkY1RUl2d05Ud3N5SE1VSEp1U0xJbFVCWkh3SThCTHAx?=
 =?utf-8?B?WW1nSUd1VjBFRkljNTdXOEtkZjNRUXFJaTcrUTF1ZXZ6VVlodXFLeFVWVmU4?=
 =?utf-8?B?bnh3eGF2cHUrT2taZHp6RmlabWNiWC9mQjRVbVpMdmU3bFAvQkJtamcvbDls?=
 =?utf-8?B?NHBrU1RTeGpsYXROUnU3VXROSHJydUNFMTkzR2crRk1Oc1h5blJWbjZYa0NR?=
 =?utf-8?B?bStSVy9mRUZ5UnI4U2xvNXNYMml0UWVGQVNPVy9nOXNZbDVOWU5YajVJN3ZD?=
 =?utf-8?B?dEZzY1ZaS25PVXQxUmpqMWw0RWR4THlYNHFUV3hRMWZNNTJST0gxK1NaUEQz?=
 =?utf-8?B?cStXdmZKMUpmdTI0RXhHNzhRcDdZTWF2bU9zMTRXN0hIdnAzcTYvcGVoSkNK?=
 =?utf-8?B?TU5GY3hHVmJOSjlGVVhPcEdpSUpqVEV6Sm5Mb1Z2NWJ3SURGZXZSS2paQmZK?=
 =?utf-8?B?Z0dSbFBCbXpwY1k2RmVqaW9YbmZ4bjlrS0VvS1pxalhneS9ULzk0UFNSNjNw?=
 =?utf-8?B?RkQzb0RvMmhBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR05MB9993.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WUtBQWhSbzVENTRFUWVWeloyTm9wbituaHlOclJxWk1aNU9EcE1EdEFkMGZM?=
 =?utf-8?B?WVZvYi9LY0xQeE0rb1gxZm5LanJBQVh2dTBKaVpGNUJSWUtOWG1ETGNaWmEw?=
 =?utf-8?B?WUx5YURVM0ZtTUtHSjVYYUxFdnV2OHJVSEVUUHNmd3dpaWNZUkd5UjFpSTBW?=
 =?utf-8?B?ZjZzeTJNb0VjVDNTNWgvR1hra1RXWCtkeDN2ajNTU2Q3YnA3RW5JbDNaUFds?=
 =?utf-8?B?UkpIOEZzdEwyOHp3ZVI3OVAwTnZ2bnhyR2hxY3BGbDBMRWFjL1hsSXQ2bTlE?=
 =?utf-8?B?UFJZV0p3MDBsMmdaWSs3OEZUVWcrV09NSzRZRzZBMkxzQUVzQ3NhTlpIaXho?=
 =?utf-8?B?ZXQ3aVAzSlRIRkRKMGI1UjJ2blhGbENHMEtaZ1oyNUo2dDN1Ui9nalB6TFAx?=
 =?utf-8?B?Y2k0aTQ4YkZCYkY1cVVHMkZRd1ZWdHBnU0YwbExIV0p6ak1rRWNhZWEwdFVv?=
 =?utf-8?B?c2t1Q1N3TWF0eWc5L2pKK2lFenU4M2IzcXFPMS9JL0VDbndvcFJzZDFmSDM5?=
 =?utf-8?B?bUoyK0ZVMmg5ditOcVVjdjBGSkM5QW5xRU9CT2xRK0gvQ0tZNFVzeTMzR2hm?=
 =?utf-8?B?dWV0ZzN3R285eHpMbzIwcktEQTI0Ly9iNjlLaGltUnVhakE0WlN0RDdGWmxa?=
 =?utf-8?B?cWkvUzhiaDE0a3Z0MEJJMVBGRDlsbWZsMTFaeGZWa1lhLzltWG5QR1lGaVNJ?=
 =?utf-8?B?WWZnMVI0YTYzUHc0d0FoTTR5V1pGNUdoS2dwLzE1MHNMUmk2K3psTXowYVR4?=
 =?utf-8?B?NzVITHhkalZHYjFxSUttK1pIUjBkK0FBMmlFZDRhK2lvUTF5ZGNZOHJ1aHRN?=
 =?utf-8?B?U0F1UVdxU1dlZXZNVFh6ZWdpcmJUL3Z4RVYxS1RiT2I3NGpiUzFLQ3hJZWIz?=
 =?utf-8?B?U2lLdmdGb0lQb0RZZnEvejZYNUpkdGZHL3NzenpwNXVRamlscTAyMTlabjA5?=
 =?utf-8?B?S0oraWpDQW1Ea3BiRGFSMUYvdFZDY3JmTmJSZ29JTGx6c2UzMFdmbzNHbUly?=
 =?utf-8?B?V0VHYmFmMExkRVhKMGd5SXdEUUVzS3ZhTTI3Mjd3OXNwbFFDdkt4ZHhhc1dj?=
 =?utf-8?B?SWZiSXVWTk5yazJlUVhSeXBtMm1TSDRySzVhTmkyZ1ZoQXFnNG5RbC9YRDl1?=
 =?utf-8?B?QWNFRXpQU25WNXVOZldxQTRScFhpdkducVdtOFVMb016MDRZZTBheStFOERK?=
 =?utf-8?B?WXFocUx4UGhzMSthRGJuZGd1QXg3MlBEcGN1MHc0OWN2N3BBRGMwNlJ1aHQ3?=
 =?utf-8?B?UXNzWUtyY3hlN3NRZjVMT3F0Y3F1MlluRldUMFVxMnJ5Q0J6SFhraVMyK1J1?=
 =?utf-8?B?Yy9BSkhpYUZtdEdHUEpJYXdlZ1dhL0xhbldzWGMwMy9sbHNpQlREUkk1V3Ay?=
 =?utf-8?B?T1RlUVc0WWZuWTZMVXJDZVBYTEZOT0tUSkRZeWpaRm5KZVQ1cFp2K2ZmOWxz?=
 =?utf-8?B?SG9pTmc4QmhNWU1XdTNVZFJDQjluMzg5T2M4OGZsNzlYTENVQytJVTlqV000?=
 =?utf-8?B?MmozR2ttWGMvdWRqYXM1L1RQdmI2ZVdrTUZidHpLUlRMSGVqcFZoR0hONzZu?=
 =?utf-8?B?OWVCdVh5QnJ6S0ZqMWFYTE9CNzdQRFlpWHcyTHQxRFFtWktqa0l4eEQxakZ1?=
 =?utf-8?B?MkpjU2RBS2UrTDFtZUJnV2pwRUVLTFQzVGZ0VkY4ZEZGUUV0NEJQM0dOM0c3?=
 =?utf-8?B?RS9EM1VoYkk3UXdKSWUwL3pjWTRVYkNnZEFhNWhzalU3anpXOTd3RnZXWTRk?=
 =?utf-8?B?a1lYQ1F1VXF5TGd4QzFGQ0EvZ3ByYklvaVdveTU3Y2preEx5b1V1VVQ0M3dy?=
 =?utf-8?B?R2JKdW53eDZXUW9JaEp1ZWlVa3V4N21MMFdwQ3pZMjNBVm1hSnpIaWRxQTA3?=
 =?utf-8?B?VWN1ajMybHprM2lQR3ErSGlwSzBTc2xQMTJpSWczNWN4akxWVGhzNDlnMGVy?=
 =?utf-8?B?OFJ0c1RRNUczcXhtdm9PYVVxUG9tMVJhMFZOTFFIRDliVUt0Y0RCQ0JBcWdq?=
 =?utf-8?B?ZExWbjVaVWxjbFpTazdRNUxPUVp1dSsvNkZjN1cxZ3ZFTzkxNW9rMERndmxW?=
 =?utf-8?B?R0krSDJpQzVmekNTczJUdVE5TUN3VVIxYlFoNUpDc2dKa0kyYmxKQm5tRlhi?=
 =?utf-8?Q?x21+E/BuwTNg6BjtU13FKJ0w7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: aaronfriel.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR05MB9993.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fdcfbe7-4d00-4b99-0fa3-08ddac276002
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2025 16:12:07.0425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd1ff30b-4659-4018-98d4-c7ec5f672515
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4r7025jHkxyS3s+12GXwVXaw6KG4tdoAxDGdCXSNRSHSjeVnm9/8xYfjTQSAHVEEpt3/SvpUMfrSbCGgR2plgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR05MB8568

PiA+IEknbSBsb29raW5nIHRvIHNlZSBpZiBJIGNhbiBzdWJtaXQgYSBwYXRjaCB0byBmaXggdGhp
cywgYnV0IGl0IHNlZW1zCj4gPiBsaWtlIHRoZSBkdXJhYmlsaXR5IGJpdCBmaWVsZCBmb3IgZGV2
aWNlcyBtYXkgYmUgb25seSAyIGJpdHMsIGlzIHRoYXQKPiA+IHJpZ2h0Pwo+wqAKPiBUaGF0IGdl
dHMgeW91IHZhbHVlcyBvZiAwLTMuIFdoeSBpcyB0aGF0IG5vdCBlbm91Z2g/CgpJbiBiY2gyX21p
X3RvX2NwdSwgaXQgbG9va3MgbGlrZSBkdXJhYmlsaXR5IGlzIGVuY29kZWQgd2l0aCBhICJiaWFz
IiAoZGVmYXVsdCB2YWx1ZSkgdGhhdCBtYXBzIHswLDEsMiwzfSA9PiB7MSwwLDEsMn0uCgrigILi
gILigILigILigILigILigILigILigILigILigILigIIuZHVyYWJpbGl0eeKAgj0gQkNIX01FTUJF
Ul9EVVJBQklMSVRZKG1pKQrigILigILigILigILigILigILigILigILigILigILigILigILigILi
gILigILigILigILigII/IEJDSF9NRU1CRVJfRFVSQUJJTElUWShtaSkgLSAxCuKAguKAguKAguKA
guKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAgjogMSwKClRoaXMgaXMg
cHJldHR5IHVuZm9ydHVuYXRlLCBiZWNhdXNlIGl0IGxvb2tzIGxpa2UgaWYgSSB3YW50IHRvIHVz
ZSBSQUlENiAocmVwbGljYXM9MyksIEkgY2FuJ3QgcmVwcmVzZW50IGEgZGV2aWNlIGFzIGhhdmlu
ZyBpbmhlcmVudCBkdXJhYmlsaXR5IG9mIFJBSUQ2IChkdXJhYmlsaXR5PTMpLgoKSXQgZG9lc24n
dCBsb29rIGxpa2UgdG9vIG11Y2ggd29yayB0byBhZGQgYSBmZWF0dXJlIGZsYWcgYEJDSF9GRUFU
VVJFX2R1cmFiaWxpdHlfYmlhc192MmAgd2hpY2ggd2hlbiBzZXQsIG1vZGlmaWVzIHRoZSBiaWFz
IHRvIHVuY29uZGl0aW9uYWxseSBhZGQgb25lIHRvIHRoZSAyLWJpdCBmaWVsZCwgbWFwcGluZyB7
MCwxLDIsM30gdG8gezEsMiwzLDR9LiBUaGF0IHdvdWxkIHN1cHBvcnQgZXZlbiB2ZXJ5IGxhcmdl
IGVyYXN1cmUgZW5jb2RlZCBhcnJheXMgYXMgd2VsbCwgd2hlcmUgeW91IG1pZ2h0IHVzZSBzb21l
dGhpbmcgbGlrZSBSUyAoNTYsNCkgZm9yIGEgY29tbW9uIDYwIGRyaXZlIEpCT0QuIFByYWN0aWNh
bGx5IHNwZWFraW5nIHRob3VnaCBJIGRvbid0IHRoaW5rIGFueW9uZSB1c2VzIHN0cmlwZXMgdGhh
dCB3aWRlIGluIGEgc2luZ2xlIGFycmF5LiBBdCBsZWFzdCBub3QgZm9yIHNwaW5uaW5nIHJ1c3Qs
IGJ1dCBpdCdzIGJlZW4gYSBsb25nIHRpbWUgc2luY2UgSSd2ZSB3b3JrZWQgd2l0aCBlbnRlcnBy
aXNlIHN0b3JhZ2UgYW5kIEkgdW5kZXJzdGFuZCB0aGUgcnVsZXMgaGF2ZSBjaGFuZ2VkIHdpdGgg
Zmxhc2ggbm93LgoKSSBjYW4gc3VibWl0IHBhdGNoZXMgZm9yIGltcGxlbWVudGluZyB0aGUgZmVh
dHVyZSBpZiB5b3Ugd2FudCBtZSB0byBzdWJtaXQgdGhlbSBhcyBhIFBSLiBOb3Qgc3VyZSBhYm91
dCB5b3VyIHN0YW5jZSBvbiBMTE0tYXV0aG9yZWQgY29kZSB0aG91Z2guCgpDaGVlcnM=
