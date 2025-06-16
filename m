Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11020121.outbound.protection.outlook.com [52.101.85.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A22D7263A
	for <linux-bcachefs@vger.kernel.org>; Mon, 16 Jun 2025 00:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750033312; cv=fail; b=gONjaUC+hEis1VD/irkFSkU2tqNPW7ZEBRTgUazIJu/MLiQ6+WL8esxu/rcTYN6PVCbwzQ/yW7wz2lDMm8v09LcCXS171s2rvKopuYiuVgLPrAeEylZY3UPbZCgZdUiIPR5bJakthhw1/VtW/J6NqdLIYiYn8slDOPpVt+CkAV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750033312; c=relaxed/simple;
	bh=ipiBQQH6/GHm0Y4mY0OHJlkmgsMbwgXP5eV8wUaNHp0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LaG7BLcOcSKcCB1/KxlDAtMX60tNrwDfdeEA2ygOTF+SWiMh/bcJV9Odu8iOr9cclYyLBrQyu6TDLI4M/9GQwJKsy0Qv//il8QNNARRrp0D+Sg4Ws9ATDeNRV5dCropFrU+BeZEXhHBxFqoFoDhce6b8HitKolcGJ681n0gdrEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaronfriel.com; spf=pass smtp.mailfrom=aaronfriel.com; dkim=pass (1024-bit key) header.d=FRIELTEK.onmicrosoft.com header.i=@FRIELTEK.onmicrosoft.com header.b=SjYbgtzJ; arc=fail smtp.client-ip=52.101.85.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaronfriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaronfriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=FRIELTEK.onmicrosoft.com header.i=@FRIELTEK.onmicrosoft.com header.b="SjYbgtzJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=snghi0MJDJ87R4RG91cXlQMEIIusTHf8UAAYFXdiDIFnLGaXjxNf8EgShEBoshJiPOPW4lyN6jCV8My89YYyMWNw2kSJgVyCQ+HdrIp5j5ogH0UVtGOjwTnOJh61CwT3+m1I3HvyjVGMGANXSPE4yXSNDftDRC/L3CaEMDoaZSUJUfsk9DavMJIztTfs5G3utZhkzg7Ryp18x9PpVFvjtKLA/FOdJwtqyYioNdpP71R9MPsdVLLWeg6ObuxcXBn5Qtgaq1E8ZMIb5/uzsyKR+DxLEEiCgZcjA3TFG7klSo4+wKYPnnALghvYNqaSNRC3tlazxL8Eu6//C0ZPOd5FSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipiBQQH6/GHm0Y4mY0OHJlkmgsMbwgXP5eV8wUaNHp0=;
 b=UqY++4bbMOh17P2qBvA7gwHhZ2FRj/+AEdcLsBMPyVaE+N9zhUhI3uzGr6XduGg7M6Rygd4ND/EqR6fin/uwoy7NnC1iJfH3RvZIO36kJvSDzo68uBlfcEM5kL0mkwPCid/fjwD0jUw0BrUZm4mvz2D5zN/Otz7mCH2XxfKyoebvN/tovUnmE/KG6NYh3HZPd3+KyWXdemz2oG484VUKza7SJ2CEqJ15wTodYrt/1Kyo4KcwTr/TEuymdCyo8RuYK+yXNQZ5thbMV2CsJ0dCzTqqFlHGhCji0sZWmyJywNQHtvJfX3TWPlXjIUVHcai6I9Bm8bdPx2rS2zH0hjOohQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aaronfriel.com; dmarc=pass action=none
 header.from=aaronfriel.com; dkim=pass header.d=aaronfriel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=FRIELTEK.onmicrosoft.com; s=selector2-FRIELTEK-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipiBQQH6/GHm0Y4mY0OHJlkmgsMbwgXP5eV8wUaNHp0=;
 b=SjYbgtzJ/evuRoK7T95K6lONLcYS0LaFElxs/S6hcHSqlKCRmf3OpxVBbNasSh7iSKuNGAWbyCdCrr3v5v2u8dYQLY69KWIKlKdWuLtvmexUzh7cZsOxWHobz4Wrd+GyYp4wvWyuQesdQCwlsSNLVDziVM6Geeg23o8cv0FbYnA=
Received: from MW4PR05MB9993.namprd05.prod.outlook.com (2603:10b6:303:1ef::21)
 by SA1PR05MB8343.namprd05.prod.outlook.com (2603:10b6:806:1d2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Mon, 16 Jun
 2025 00:21:46 +0000
Received: from MW4PR05MB9993.namprd05.prod.outlook.com
 ([fe80::da:f56d:ad76:326e]) by MW4PR05MB9993.namprd05.prod.outlook.com
 ([fe80::da:f56d:ad76:326e%4]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 00:21:46 +0000
From: Aaron Friel <mayreply@aaronfriel.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Issues setting durability on new devices in bcachefs
Thread-Topic: Issues setting durability on new devices in bcachefs
Thread-Index:
 AQHb3aG7BcdLvKRiWEq49GHsrqA8x7QDmi8AgAAgvtqAAHI6AIAAMKqHgAANLQCAAAXK64AABFKAgAAjfkI=
Date: Mon, 16 Jun 2025 00:21:46 +0000
Message-ID:
 <MW4PR05MB999372E527C87E73BF153992B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
References:
 <MW4PR05MB99934C43FB32313C921D7765B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <qj5wzirldvxhd6om54mnzenq52hdh25zbvzhtirdgumo4zwh5o@hwccwflcdvyo>
 <MW4PR05MB9993BFE56AEF738F894D5586B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <yfxm2uhmxqavi5p5q5l5hbcn5sgrl7tviccclav2qr65muvd4u@jawmmtvgljsd>
 <MW4PR05MB9993E5730DFC5449D826473BB571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <6v4xbwoewpmrl7uga24yjvft4dpeis65p42vez7tgi7eiuqpbq@4qvl64d3bwq3>
 <MW4PR05MB99933BF310D75964CC5FDAE7B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <dsoyo2a3h2s52sznnujwqeebdzqxmjr4jgx2vjpknpvdfktnpw@7oxvl3ntjebk>
In-Reply-To: <dsoyo2a3h2s52sznnujwqeebdzqxmjr4jgx2vjpknpvdfktnpw@7oxvl3ntjebk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aaronfriel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR05MB9993:EE_|SA1PR05MB8343:EE_
x-ms-office365-filtering-correlation-id: c70f9dde-dc6e-4213-ab9d-08ddac6bc784
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dmRzNGxpd3VDaFNUTlI5RUhWSGFTbFhNUTFxOXN5ZFNEdW40RXRGc0crQUVp?=
 =?utf-8?B?M0VsVDIzRk54Wko2MU13OStHcmJLLzZJRFdQOHRMYzY1VzZodklKSVRadCtD?=
 =?utf-8?B?VmlnSnF2UUFvYUFVS01Zcnl4N2F0REkyZVFnM3VoVTI3V1c2UEg5R1NDVCtB?=
 =?utf-8?B?azBBLzBuSVN0WXAyUHZJWGR2QlM0TnYrUVMwRnZyc2s3TmZjOVFnNXRTS1J6?=
 =?utf-8?B?a2J3VWFodVJVOHFMQlZOSWdFc3JKZnhHOTFsTHJzb3h6VVFvS3lvU3dobE5t?=
 =?utf-8?B?MDVjRzAvbklNT0ZmSHQxV1VBa1p5NFNsREZ4ejVHNTk1V3E2OVc5VEtrSFpq?=
 =?utf-8?B?UGRLVGdpL0paL0NHdmFlTXpQV3V5RFArVVdndkM2V1crUjFpVGdpVDVUdnZv?=
 =?utf-8?B?cHJaLzd3bkZyWXp4ODQ0djVwT082MmpERUtoZUJkN2ZkcjJ3NkxlZUxTaUY3?=
 =?utf-8?B?M0oydVhhTGlleWhuVTA2TkZGaDlzZG1BSk00SVF3RUlqdlhTN29HQjVZODFT?=
 =?utf-8?B?R2FjT3hzQ3pmN09aNXgranVUS1RhMGJ3dy9UL2tQWi9YRCt3Yng5WDVoeHYy?=
 =?utf-8?B?NHFCMFk4VWNFSERjZ0M4QlN2REFEWUNwNHFBMnpYM0VIRmVDdjQyd3htRjhQ?=
 =?utf-8?B?OHpvTHAxNENnN0tZNkFoR1NiZG1KNlNRNHl3bUhxRE9wUXgvL1pHUU00Z3BG?=
 =?utf-8?B?VmJPRlFLajF4ZXF2R2ZCc29jRkpCT1QzOVYvbUVETk8yM3FjaE8xNkZXNkpC?=
 =?utf-8?B?cXVtOTYrNmtVY1pDRnNjZmtJWG5MYXZwcDlmU1UvYklnTHY0QVR1MmlMTkwr?=
 =?utf-8?B?N1hibGN5eXlLTFhCYzU2djBHbTRzQmxGbDY2cHMyTnlSR3Jjd3hCRVNJU0wr?=
 =?utf-8?B?TkZWMml0U3BHSjh0c2gwTlo5WGJqazByWWNUSlMwcUpYU1BhQlJBbU1yZkJa?=
 =?utf-8?B?WlJkMGgrUUpSZmZmYXBYa1ZOdEF3a2F1RTVzcXdpc2kraVllYmFNMG5SMk9p?=
 =?utf-8?B?Y2xFMlgyZVlvU01ERE4wczlpc1lsNnk2ZFJJZHNrUzVIWWpBQlVlUVRpcFpi?=
 =?utf-8?B?K2hQU0tidFNHaWcvVStSaDlsbVAzQklDRDRPN3BQbk5QSmNxNmc3NnFBQjBU?=
 =?utf-8?B?My9QWTNsU1BhbG56Q2NKT0RxUVFvc01UK2c4OTd6aDd3cHBaUDJhK29yU09t?=
 =?utf-8?B?ZEMzQjVaZVdIRHYxaHNFb0NSV2gybDIxMzFVUGJudlkyK2JLYUtEeDQxTy8x?=
 =?utf-8?B?SjF0Vk5qRUpJQzZlTlNUeDdXTE4xWG4ybVVoTytwb09xZjN0RDRpZVdtbDA4?=
 =?utf-8?B?a1ZJb092bmJidko2S0lUU0R0YUY5bWRpNVRxQnY1SVkrYkc1MkFBeldITkd0?=
 =?utf-8?B?QjE2QmxJczQ1eGZmVWlJc3IyZFVnKzUzYWYyTzVWZmIyZDE3N1NDZWZYYWVW?=
 =?utf-8?B?M0t3a1RmcG1kUWdaTDVYYXhrcW9oYU1XR1l6NVpMQi9XTTh3SVJLRlZPWDMr?=
 =?utf-8?B?clVzWTB2ZmVrRDFXS1gvMmtCc1YvUzNBMnptQ0FCRlJmeUpBeVNYVjFpdHR0?=
 =?utf-8?B?cGUxaUxnK2hQZDdRSHJFa0ZxWmV2bWdNUEQxUXJWTGh6dnlBYzd6WGkwalNZ?=
 =?utf-8?B?VDk0cG9FeUNSeXBqUkdIS2tmZFhnZHRxb2dSM2xHWXhrb3ZFWWlKaGUzb0c5?=
 =?utf-8?B?VkYxZU9VcGZSb00yUEhzZ29JZFBIUDhvaEtCckpuZ3ZldTFnTGtab1laU1dr?=
 =?utf-8?B?Sjk5YksycU1Nb25sR3JYTDlzTDJxK01ZMTdzZ1NNcXN2S1Z2SGluV3NXdDgw?=
 =?utf-8?B?TVlaWCt6aWYvbVJpWjUwdjdaNkRoSUV4WDg5UVJkUDRhUG92YjcwVlBsRFNT?=
 =?utf-8?B?Q0RvYTFNcVQyYmZIOXowK2ZpczBWbEh5SzlLSndnYllEL2x5YWk4Q0ptNVBL?=
 =?utf-8?B?Q0lNbzB2T2JURHhPaDBWWEIxRjNUdXFlWVRPK1JnQVFmcFFtVEpQU2tUckpL?=
 =?utf-8?B?WUo0TmJzN1dnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR05MB9993.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RTREQnZ1enN4OVBqYWxiY2s4aStYTEFZMFVQTjQ2NXBqVlhYT2dTdTNGUXV5?=
 =?utf-8?B?NnJQc3dRMjRBUVhNUjdpR25kVGwwdW95NTcrSHZvUVUrUmdiaXh1TlNuSGlU?=
 =?utf-8?B?am9QMUVGSXNWbWlNQ2RBa1VtbnZBM3JSWlIrclprQ1hZczZlTWIvd1ZsTG1G?=
 =?utf-8?B?VmUyWVk3dHNzbGNkZ1c5YmZaRk8wYXBxUllEUUl4NlY4N09KcGRLWU5kRUQx?=
 =?utf-8?B?NWkyQ3grS3l3dmVJWkh6SnZqTHVvbXdxL3Y3aFpqeGJEUGlDVFpRR2I4K090?=
 =?utf-8?B?RWN4NjdwbDV5UUhmL2UwcXhDSC83Qll1emEyYTFzUGQ3RllVaWpWMGs5eERD?=
 =?utf-8?B?K2xsb1p4RXRCREZCWEpEUGVOQWc1Uk1WL09Ma1pheHJhb25sbzdhVnJDZE1H?=
 =?utf-8?B?QS9vMG5qeGs0UXJGT282N2VEaytHZHJTQ3ovOGc2QTloY09qNEdyenM3VUNZ?=
 =?utf-8?B?Z041azF3c2MyRGlwN0x0R0xZdFcwVll0dXQ2M1lhTWpCRVlQR1k4RWt6OHJO?=
 =?utf-8?B?d1hHTE40WU1uU3BLNi9xbXVwQ3JqTEZnajllTmV3KzRjcWo5UTFYR2JIbTZj?=
 =?utf-8?B?cmVtejdKaVhmUGFaUGsrMkFSYVdmdWVZcko2NXFRVjNoUlRjem5mS05LdDFS?=
 =?utf-8?B?c0dQeWZ0NlBkVXhMVHNGTVpwdjJDc09ISDNNWXRPQzJhMEU4a3pvUVZHQzh3?=
 =?utf-8?B?WGFMd2h0ZHduZHBMUU9DMFlhS2VkeiszTmpUTkFRRGNxUmVKdFUyWHNGdGJa?=
 =?utf-8?B?VHZ5dWNDYU04WDYvWWtPbzlUdjZ0a0VFUndMSW9kMlkyZHdKZkR5LzVEakw4?=
 =?utf-8?B?ZU9rVkg1RjZIUVVLZ2orb1dnNlJVL3V5WXdwbDlsNUsvVUlKaGZuRFYrOU8w?=
 =?utf-8?B?RUNKRGtRZTgwSldEQitRc3V4VlcyV0cvM3JESitCZTE4a3VoR1JNbXN6NmFS?=
 =?utf-8?B?L1M4cTJzaFUrdmR0cWN4YzFuSWljbkxRODdJN3YwQnI1NHhXYmdWeGc2aUpU?=
 =?utf-8?B?akZlL295bzA4NTZvdy9xS1VmT0tRY0w3YXZFbmIwK3A4ZkI0ZHdDam81ZElS?=
 =?utf-8?B?QzdnN1ZxT1ZQU3pKN0Vad2x4N1FCSFZGSGwvTElZMGgrS3JQSHE4K3MzdmMw?=
 =?utf-8?B?YjcrWjhLYkQ1b2g3R3I2VWRiSlM4d2JsV1ZsdjNqWUJONjJzMW5QY1Z5ZkRI?=
 =?utf-8?B?dUdoSnhBZ2MwVU91T01HaVJaTmo3UWttdUhCNTNqS2YzaVpSUXFiUE9nY3hz?=
 =?utf-8?B?ZVBIMnNzRGxjenZYTmtPbzV5cDJseG1qRWFWRkQ2WElpUytqRExJV3VFZUxp?=
 =?utf-8?B?a1BORVV1STVNTnpselFuck5tSklzY2d1WG1RNEVyaWMrREd0Y1dxSHdkZmNn?=
 =?utf-8?B?c1haYWRXMG5TVEw4dCtyWGJsOHNIRjNqMi9NUG50cW9NM3YrMEVvbFhzc2Z6?=
 =?utf-8?B?MThtQzUvTXVYUnZxa2NDdk9CTXplUEkxdktOYUl4MFNOQXluYklEdDBJYUlr?=
 =?utf-8?B?Z0U2dmNXNUlKazJFODlFTVcyemRuYVNnSmJ0SFJQQ2JjT3FjMWtvcmtZMjFq?=
 =?utf-8?B?RnJPUjh1S3ZNUURuZmFjRXdSano4cUNsV1ZlVVVQK3phYVhDYXYwMU1EZEli?=
 =?utf-8?B?UEpsTVZGQXJCUGVNcDlkdkQyMUI0SzBwTmZHWXNIa3JScHNZUzB4eXMvdnpC?=
 =?utf-8?B?enBvZE1JWGEvd1E2UzFkREV2RVJGQWlielBZanlkUUxkMW9wWmx2ZGhHdHQy?=
 =?utf-8?B?SDJxeUYybGtIeHFQREdrZ3ZKbE9FdVpxRzRLZTd1b0krSytodjVkZVRrSDFZ?=
 =?utf-8?B?SWdqaVNpZTY0YzBlc05LejB4RW55dXdRTHhJTEZ4YWE2NXdWMVp4Y3pUZkZv?=
 =?utf-8?B?U29tdVMyazc4OG11bThvVEV5UFUyYTVlbWZscG1BOHZ0Ump1Q2YzRmR1bmpH?=
 =?utf-8?B?eDZYR3JHb1JjellnVEFmaWFYVmk0V0lKTzR1cHRSUFIrSTBQNUFDamRqd1VS?=
 =?utf-8?B?UStEaFlWekF3U3QyQkdsc2hhaGdCQmFTenpRbHBVNngxRTZmRTErWUpFTDNv?=
 =?utf-8?B?RjZQMlM3R3ZKN3RwT3Y3emltQlh6OXhoWTZSbGQ1RGQ3aEhTeVpRMUw5a3Ar?=
 =?utf-8?Q?83B15NbmHT/Cd8SrB/uwPHE8E?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c70f9dde-dc6e-4213-ab9d-08ddac6bc784
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2025 00:21:46.5071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd1ff30b-4659-4018-98d4-c7ec5f672515
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w8sdnRiac2/ua8n/PF5LxnMKC0N2kE+CXS0YqPMDuRynNco6sLXjQzIirfMj9vzqlsQD6pxV7Kipot3eJrpCsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR05MB8343

PiA+ID4gPiA+ID4gSSdtIGxvb2tpbmcgdG8gc2VlIGlmIEkgY2FuIHN1Ym1pdCBhIHBhdGNoIHRv
IGZpeCB0aGlzLCBidXQgaXQgc2VlbXMKPiA+ID4gPiA+ID4gbGlrZSB0aGUgZHVyYWJpbGl0eSBi
aXQgZmllbGQgZm9yIGRldmljZXMgbWF5IGJlIG9ubHkgMiBiaXRzLCBpcyB0aGF0Cj4gPiA+ID4g
PiA+IHJpZ2h0Pwo+ID4gPiA+ID7CoAo+ID4gPiA+ID4gVGhhdCBnZXRzIHlvdSB2YWx1ZXMgb2Yg
MC0zLiBXaHkgaXMgdGhhdCBub3QgZW5vdWdoPwo+ID4gPiA+Cj4gPiA+ID4gSW4gYmNoMl9taV90
b19jcHUsIGl0IGxvb2tzIGxpa2UgZHVyYWJpbGl0eSBpcyBlbmNvZGVkIHdpdGggYSAiYmlhcyIg
KGRlZmF1bHQgdmFsdWUpIHRoYXQgbWFwcyB7MCwxLDIsM30gPT4gezEsMCwxLDJ9Lgo+ID4gPiA+
Cj4gPiA+ID4g4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCCLmR1cmFiaWxpdHni
gII9IEJDSF9NRU1CRVJfRFVSQUJJTElUWShtaSkKPiA+ID4gPiDigILigILigILigILigILigILi
gILigILigILigILigILigILigILigILigILigILigILigII/IEJDSF9NRU1CRVJfRFVSQUJJTElU
WShtaSkgLSAxCj4gPiA+ID4g4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC
4oCC4oCC4oCC4oCC4oCCOiAxLAo+ID4gPiA+Cj4gPiA+ID4gVGhpcyBpcyBwcmV0dHkgdW5mb3J0
dW5hdGUsIGJlY2F1c2UgaXQgbG9va3MgbGlrZSBpZiBJIHdhbnQgdG8gdXNlIFJBSUQ2IChyZXBs
aWNhcz0zKSwgSSBjYW4ndCByZXByZXNlbnQgYSBkZXZpY2UgYXMgaGF2aW5nIGluaGVyZW50IGR1
cmFiaWxpdHkgb2YgUkFJRDYgKGR1cmFiaWxpdHk9MykuCj4gPiA+ID4KPiA+ID4gPiBJdCBkb2Vz
bid0IGxvb2sgbGlrZSB0b28gbXVjaCB3b3JrIHRvIGFkZCBhIGZlYXR1cmUgZmxhZyBgQkNIX0ZF
QVRVUkVfZHVyYWJpbGl0eV9iaWFzX3YyYCB3aGljaCB3aGVuIHNldCwgbW9kaWZpZXMgdGhlIGJp
YXMgdG8gdW5jb25kaXRpb25hbGx5IGFkZCBvbmUgdG8gdGhlIDItYml0IGZpZWxkLCBtYXBwaW5n
IHswLDEsMiwzfSB0byB7MSwyLDMsNH0uIFRoYXQgd291bGQgc3VwcG9ydCBldmVuIHZlcnkgbGFy
Z2UgZXJhc3VyZSBlbmNvZGVkIGFycmF5cyBhcyB3ZWxsLCB3aGVyZSB5b3UgbWlnaHQgdXNlIHNv
bWV0aGluZyBsaWtlIFJTICg1Niw0KSBmb3IgYSBjb21tb24gNjAgZHJpdmUgSkJPRC4gUHJhY3Rp
Y2FsbHkgc3BlYWtpbmcgdGhvdWdoIEkgZG9uJ3QgdGhpbmsgYW55b25lIHVzZXMgc3RyaXBlcyB0
aGF0IHdpZGUgaW4gYSBzaW5nbGUgYXJyYXkuIEF0IGxlYXN0IG5vdCBmb3Igc3Bpbm5pbmcgcnVz
dCwgYnV0IGl0J3MgYmVlbiBhIGxvbmcgdGltZSBzaW5jZSBJJ3ZlIHdvcmtlZCB3aXRoIGVudGVy
cHJpc2Ugc3RvcmFnZSBhbmQgSSB1bmRlcnN0YW5kIHRoZSBydWxlcyBoYXZlIGNoYW5nZWQgd2l0
aCBmbGFzaCBub3cuCj4gPiA+ID4KPiA+ID4gPiBJIGNhbiBzdWJtaXQgcGF0Y2hlcyBmb3IgaW1w
bGVtZW50aW5nIHRoZSBmZWF0dXJlIGlmIHlvdSB3YW50IG1lIHRvIHN1Ym1pdCB0aGVtIGFzIGEg
UFIuIE5vdCBzdXJlIGFib3V0IHlvdXIgc3RhbmNlIG9uIExMTS1hdXRob3JlZCBjb2RlIHRob3Vn
aC4KPiA+ID4KPiA+ID4gQWN0dWFsbHkgdGhlcmUncyBhbiBlYXNpZXIgd2F5LCB3aGljaCBJJ3Zl
IGRvbmUgYSBmZXcgZGlmZmVyZW50IHRpbWVzCj4gPiBiZWZvcmUuIFdlIGNhbiBleHRlbmQgQkNI
X01FTUJFUl9EVVJBQklMSVRZIHRvIDQgYml0cyAoc2hvdWxkIGJlCj4gPiBzdWZmaWNpZW50LCBu
bz8pLCB3aXRoIHRoZSBoaWdoIGJpdHMgZ29pbmcgd2hlbmV2ZXIgd2UndmUgZ290IHJvb20gaW4K
PiA+IGJjaF9tZW1iZXIuCj4gPiA+Cj4gPiA+IFJlbmFtZSBCQ0hfTUVNQkVSX0RVUkFCSUxJVFkg
LT4gQkNIX01FTUJFUl9EVVJBQklMVElZX0xPCj4gPiA+Cj4gPiA+IEJDSF9NRU1CRVJfRFVSQUJJ
TElUWV9ISSBmb3IgdGhlIG5ldyB0d28gYml0cwo+ID4gPgo+ID4gPiBUaGVuIHdyaXRlIG5ldyBn
ZXQvc2V0IGZ1bmN0aW9ucyBmb3IgQkNIX01FTUJFUl9EVVJBQklMSVRZIHRoYXQKPiA+IHJlYWRz
L3N0b3JlcyBmcm9tIHRoZSBsbyBhbmQgaGkgZmllbGRzLgo+ID4gPgo+ID4gPiBCdXQgd2UnZCBz
dGlsbCB3YW50IGEgbmV3IG9uIGRpc2sgZm9ybWF0IHZlcnNpb24gZm9yIHRoaXMsIGFuZCB0aGVu
IHVzZQo+ID4gYmNoMl9yZXF1ZXN0X2luY29tcGF0X2ZlYXR1cmUoKSB3aGVuZXZlciBhdHRlbXB0
aW5nIHRvIHNldCBhIGR1cmFiaWxpdHkKPiA+IGh0YXQgZG9lc24ndCBmaXQgaW4gdGhlIG9sZCAy
IGJpdCBmaWVsZC4KPiA+Cj4gPiBEbyB3ZSB3YW50IHRoZSBuZXcgZmllbGQgdG8gYmUgYWRkaXRp
dmUgYWZ0ZXIgc2F0dXJhdGluZyBCQ0hfTUVNQkVSX0RVUkFCSUxJVFlfTE8gYXQgMiwgcmF0aGVy
IHRoYW4gdHJlYXQgaXQgYXMgYSA0IGJpdCBmaWVsZCB3aGljaCBjb3VsZCByZXN1bHQgaW4gYW4g
b2xkZXIga2VybmVsIHNlZWluZyAwYjAxIGFuZCBpbnRlcnByZXRpbmcgaXQgYXMgMD8gU286Cj4g
Pgo+ID4gTE/CoMKgwqAgSEnCoMKgwqAgVkFMVUUKPiA+ICMgZXhpc3RpbmcgcmFuZ2U6Cj4gPiAw
MMKgwqDCoCAwMMKgwqDCoCAxCj4gPiAwMcKgwqDCoCAwMMKgwqDCoCAwCj4gPiAxMMKgwqDCoCAw
MMKgwqDCoCAxCj4gPiAxMcKgwqDCoCAwMMKgwqDCoCAyCj4gPiAjIGV4cGFuZGVkIHJhbmdlOgo+
ID4gMTHCoMKgwqAgMDHCoMKgwqAgMwo+ID4gMTHCoMKgwqAgMTDCoMKgwqAgNAo+ID4gMTHCoMKg
wqAgMTHCoMKgwqAgNQo+ID4KPiA+IFRoZW4gYW4gb2xkZXIga2VybmVsIHdpbGwgcmVhZCBhbnkg
ZGV2aWNlIHdpdGggZHVyYWJpbGl0eSA+MiBhcyBoYXZpbmcgZHVyYWJpbGl0eT0yLCB3aGljaCBp
cyBub3QgaWRlYWwgYnV0IEkgd29ycnkgdGhhdCBkdXJhYmlsaXR5PTAgbWlnaHQgcmVzdWx0IGlu
IHVuZGVmaW5lZCAob3IgdW5zcGVjaWZpZWQ/KSBiZWhhdmlvci4KPiAKPiBObywganVzdCBtYWtl
IGl0IGFuIGluY29tcGF0IGZlYXR1cmUsIGl0J3Mgd2F5IHNpbXBsZXIgLSBvbGRlciBrZXJuZWxz
Cj4gdGhhdCBkb24ndCB1bmRlcnN0YW5kIGR1cmFiaWxpdHkgPiAyIHdpbGwgbmV2ZXIgc2VlIHRo
ZW0KCk9oIEkgc2VlLCBhbiBpbmNvbXBhdGlibGUgZmVhdHVyZSB3aWxsIHByZXZlbnQgb2xkZXIg
a2VybmVscyBmcm9tIG1vdW50aW5nIHRoZSBkcml2ZS4gVGhhdCBtYWtlcyBzZW5zZS4gRG8geW91
IHN0aWxsIHdhbnQgdG8gbWFwIHdpdGggdGhlIDEgYml0IGJpYXMgKG1hcHBpbmcgMSB0byAwYjAw
MDAsIGFuZCBkdXJhYmlsaXR5PTEgdG8gMGIwMDAxKT8gSXQgc2VlbXMgbGlrZSB0aGF0IHdvdWxk
IGludHJvZHVjZSB0aGUgZmV3ZXN0IGNoYW5nZXMgZWxzZXdoZXJlIGFuZCBlbnN1cmUgdGhhdCBh
IHplcm8gaW5pdGlhbGl6ZWQgc3RydWN0IGJlaGF2ZXMgaW4gYSByYXRpb25hbCB3YXkuIA==
