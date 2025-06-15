Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020118.outbound.protection.outlook.com [52.101.193.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C485514F98
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Jun 2025 17:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750006933; cv=fail; b=BhFqyF951A9DKUX/JIas2Mg3QhZwQ6cFeOo2Oz5eJ/zXiRxdKhjwLd2JpUu7TYYfOoQJp5LhjsfH1bFkgzB34NREd4svXT/YLyGorouy4rE0N5VrUdiVE+RBzfL7epAZLv6xnQGw7Q7+FWObLm52Q+UXgSCRCUeOC3NM9iGWpR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750006933; c=relaxed/simple;
	bh=/5K2yUXOXRIWW0OZu2Y/I+yI4ZMrlSF0VjkSFCYCdrg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ep6TNBbyaedeCKwt3FQTzhjsSgy8R4HB1rmMkfCmtiJdDqgn234hVfTtYGhf2DiyuMTHY93+veohCeY1/UUjPCh7xKVWCeJzlr1jjepFXwYbBXAd0GzgNBCyK0AgPgYHhIy50dkcYQ55DZw/qEJjuoevpf+sLA01RbUSb5vhgjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaronfriel.com; spf=pass smtp.mailfrom=aaronfriel.com; dkim=pass (1024-bit key) header.d=FRIELTEK.onmicrosoft.com header.i=@FRIELTEK.onmicrosoft.com header.b=rev5ZkfB; arc=fail smtp.client-ip=52.101.193.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aaronfriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aaronfriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=FRIELTEK.onmicrosoft.com header.i=@FRIELTEK.onmicrosoft.com header.b="rev5ZkfB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nIuE46+d64wCUvRDPP2fqUMwUPdHfboz7PI2adnuZY/5IBiXEoNTvKHe+c0F4pnRJjpTsSvDH2cwgc/bjZHu5b+L6Q6VFcZ2CvmNshRKq/SXloLM5trTWcpDUca+BsebRupR588VvYtPquaTj/AcV+lL1zbFgeAQmy0aJeXmCY6IPv77aXyb0ocYDrAYVGVDSuQEwD6Emu2V5th/Zq3jjfF3BLZ+Y3GLUfjdnyFIBPTx7lz6W6hkfEn3mryjxcVCb2pTJWOMoGHyeeonUTG4LoL8yGPz/CafYnAyq69FguvSx5M3+vyYM6m0qUy8906ZVdYCjt1sfSG/2uaIAEH4ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/5K2yUXOXRIWW0OZu2Y/I+yI4ZMrlSF0VjkSFCYCdrg=;
 b=GFSis/FneCLBQxF7l4bnC5rQCS8KV2WuJJYHzxmk/wxzvLbls6ihSzuqfTW5u4nVVJu5mTmootKEWzYEpQWCeo6v119aQfOq2CRLLk4rH1NVy431FupT6aGhKP8sEY/ywLdf5XWtwdigBq/LV+UviX3uompG+xKATWL1NT3GiY7bYXcZCFhKN5rgnuHGn5mYywIBUpt4w31fCkaYNw6kDKxfTj1OEWWU3p8ej2YkCbiV+tYWZFguBJC299hqgsMAK6BISthqpI6rN+pPvDLuLWh2iZwAG7jngXV5yKe18k1NZbqsOWdwNCBt13hqBswJ4iNemxsbNHxW2rZwWV/0HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aaronfriel.com; dmarc=pass action=none
 header.from=aaronfriel.com; dkim=pass header.d=aaronfriel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=FRIELTEK.onmicrosoft.com; s=selector2-FRIELTEK-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5K2yUXOXRIWW0OZu2Y/I+yI4ZMrlSF0VjkSFCYCdrg=;
 b=rev5ZkfB6l95jrM2IXsk6NOkhTbBoElOTCB+IKzYG33PBZnuKaF5HIBq11/2HDgYatxje2HKIbKagDIQhbFEVtKPjF5DDJnh6fALc36GbaVc6bjo5pmhq5uF7PSZ+4likA8SPSLzG0YFb24lWi7wAEi5qP/Oryly8o72+Q3sLcs=
Received: from MW4PR05MB9993.namprd05.prod.outlook.com (2603:10b6:303:1ef::21)
 by SA1PR05MB8064.namprd05.prod.outlook.com (2603:10b6:806:187::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Sun, 15 Jun
 2025 17:02:07 +0000
Received: from MW4PR05MB9993.namprd05.prod.outlook.com
 ([fe80::da:f56d:ad76:326e]) by MW4PR05MB9993.namprd05.prod.outlook.com
 ([fe80::da:f56d:ad76:326e%4]) with mapi id 15.20.8835.027; Sun, 15 Jun 2025
 17:02:07 +0000
From: Aaron Friel <mayreply@aaronfriel.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Issues setting durability on new devices in bcachefs
Thread-Topic: Issues setting durability on new devices in bcachefs
Thread-Index:
 AQHb3aG7BcdLvKRiWEq49GHsrqA8x7QDmi8AgAAgvtqAAHI6AIAAMKqHgAANLQCAAAXK6w==
Date: Sun, 15 Jun 2025 17:02:07 +0000
Message-ID:
 <MW4PR05MB99933BF310D75964CC5FDAE7B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
References:
 <MW4PR05MB99934C43FB32313C921D7765B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <qj5wzirldvxhd6om54mnzenq52hdh25zbvzhtirdgumo4zwh5o@hwccwflcdvyo>
 <MW4PR05MB9993BFE56AEF738F894D5586B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <yfxm2uhmxqavi5p5q5l5hbcn5sgrl7tviccclav2qr65muvd4u@jawmmtvgljsd>
 <MW4PR05MB9993E5730DFC5449D826473BB571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <6v4xbwoewpmrl7uga24yjvft4dpeis65p42vez7tgi7eiuqpbq@4qvl64d3bwq3>
In-Reply-To: <6v4xbwoewpmrl7uga24yjvft4dpeis65p42vez7tgi7eiuqpbq@4qvl64d3bwq3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aaronfriel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR05MB9993:EE_|SA1PR05MB8064:EE_
x-ms-office365-filtering-correlation-id: 1c61e1dc-a6d0-4c68-b3aa-08ddac2e5c3a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TlNacjNLOUIxUEU5ZVpWVG1sbEpjYWViaXdsMmdwSDRSTDdsTlV3SXhEaXA0?=
 =?utf-8?B?RHRXNWNyMHdkU05nR1lmYjdHNWl3SzlrRGpXU0lPenJaVzFzTWFZcy90WnVq?=
 =?utf-8?B?amlLYSt4LytDbHlPc2RvMEFaZFNrZk9FYjI1TTNlVlpBd2EvLzcvZUh2eGda?=
 =?utf-8?B?RlRvUGlvZ3VPZStqSzBSRzNmME8wWUc0RDNFaGRJOGNzWmRkdzJLbzVaUlJL?=
 =?utf-8?B?VEFVcUkrdDV0Z1UvR0pQcEt6R1AvYndVOTlUOXd2WmlOQzdOWWY2Zk1MN2d1?=
 =?utf-8?B?YktJVCthZlRDZGFZQ2tmTGt5a0RqRFNvSEVkQUxtTEV6QjdrRmlzUSs2VlBz?=
 =?utf-8?B?aVdmajNwcG5yV1pWRHRIc0VTVWRiajBFS1NEUE9vMWd3SHlPZS9NdzRyU2Ry?=
 =?utf-8?B?c3VSOXdRNEU2a1did0w2SlBlRnVCRzFnd2JjbUcyZEVBbVBDRXhHeEdiaUxu?=
 =?utf-8?B?QkNCaXdkZkY5NUxlNjhQMkNMRE5MdithVXpMVlhXOHd6YWJ1MVo1L3E5QWFt?=
 =?utf-8?B?VzhiQ3NURVMwdWF0SDV2Y3RSV2pTb3JvNWpPMDdpWTlBdHRKQWQ2ZjR3L1pX?=
 =?utf-8?B?Sk9XYzJwb0VYQWNEbmsvRUVkRGhTQ3M3ZlJiU2t6NmhrbHBrRkdtbWNpdkJW?=
 =?utf-8?B?NDczcldxRlVSMjUzTDNoMjBLaEJ1ZWdMSWNCcStNVllGem1WekVDYlEvenVF?=
 =?utf-8?B?VHV0RzhIdTJ2cEtRdHhPSkJZUFU3NkVSMUE2bjNDaXNIbk45QUZtNG1pMXlQ?=
 =?utf-8?B?L3JmS2l6Q1JXYk5vSjE3dzE4Z0ExNEk1K0JZWlVtLytUOW1UNEpsWmdGOG9C?=
 =?utf-8?B?R1B6bzdhL0ZnanN0bnBzdGc2bjdURFpGcXE1RkROQXV1dndaV0ZuUy8zYTEv?=
 =?utf-8?B?K0FweisxNFowUzIvWmo3ZXlna2Nydlo5Tk9NUWJ4M2d4cDRnQ0VZR1Z2eFN0?=
 =?utf-8?B?UlpYaUVCWTNydDJTNkh4QXYyTXJ5eFI0RFBpM0E2U3V5RXZHRnljTWdka3lB?=
 =?utf-8?B?cUZoZ2lpZStFVGdRVEI2S3lrU1hrZ3Fod1kwb0hnaHJWdFRaT3VaelhWYUxW?=
 =?utf-8?B?TWhFdjFnM1NBK1FjemRsK3ZhLy81M0JTY2kva2tIcEExM3p4L3JKS3NSM29z?=
 =?utf-8?B?bnBFaHBidjFQMU8wZ2J4TDBqSlkzb0dkNzZJWlBqQkpIdGU5b3NRTGE2ZlhL?=
 =?utf-8?B?YW85OXJ6WFVIZFVaellRa0xsYzI2YkxZWFVENTNLb2NVZHpyRlV3Z25SQUEx?=
 =?utf-8?B?SHkyOXZja1ExVGJmU0NZcjc5N1JIbWlhTk56K094WXFsSS9XeHhTajd3VkJ3?=
 =?utf-8?B?eEI4R0ZQeXZHbnhxTHNvdGpQNC9IUjluWUhVcUJpYU5la3NrR1FFN1AzQTRt?=
 =?utf-8?B?eGNqMTRSRUdWMVdreHRJMGlKdnlrL2NtOUhqSEtCTHhldVVvVDVncFBvV0ty?=
 =?utf-8?B?UlFINVFsOWtZcE04aU03dDRua1lGaHM0WFlGSENtaXRSaThiUzhQY3RwWlJY?=
 =?utf-8?B?NytuaTJJSVFPb3RnN28rNU96cUtmeDRvREdkMExJMUdKQWVNbm5DQ1AxRnV2?=
 =?utf-8?B?MFg4STZYQVBzdjlqL09ZSCsrU2d3RGl1b0FsZW8ySGNlUHdSblVTM29ycTVN?=
 =?utf-8?B?RVB1YndPWWV6WGtGU3cxK1AxNDBmZnRXa1p4OUhUR29JeWZZbGpVakNXMGdo?=
 =?utf-8?B?cHBCTmpkYkJWTElBcDJOV24rNTVkaGY4S1lpRVVXL1VqZUJCSHEwaENuSEZ5?=
 =?utf-8?B?RVRYTVRPOWNNL2hWREdCOUxjZE1qS1pMSHFBVkRkeE4yaHd6TGVuTm1JelpI?=
 =?utf-8?B?b0JZeVdIcmxXM1NyREJxWlU1bWx4VmhzL0NnZWR5WFUyakJubFZ0ZkFNSnMy?=
 =?utf-8?B?bGt1eE5kdlVtU3B4UmpoeFN3V3d2QmVzcWZMS2tLanlISWJmNk9jc0U0Tnkz?=
 =?utf-8?B?a1UrVjRQbThhSjVScXpCUUR4cVByYTg0dmcxMGR1eXR1NHZ6anhOdVl5ZFE2?=
 =?utf-8?B?YXRtbkNvYTlRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR05MB9993.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c05saHkvam4zVmZ1R2U5L3paVFlDQ1ZETkFPZTFOWGMvUHg4RHZnSy9ZcHgv?=
 =?utf-8?B?dXFNYWJTdmhrM2ttYlV6TndKYnJNMVN4d0hLQnoyNGVYejROUTd1VVRRcHVJ?=
 =?utf-8?B?NnI0dC9acm56MEFyZGZma3R0RmhaUXVsOXhGVjA3QitVMVZzNWlMTTJJSURD?=
 =?utf-8?B?bGoySldSb21pN1k5bmJQTTVSRGFGdTU4WVVNUk1yRkh5cWU0SnRPNnIxMisy?=
 =?utf-8?B?alJYM2ZLam5rckI0TjQ1R2NjYzJKeFlTT21NTTQrVmkxVVhZZE0wV285L3Mv?=
 =?utf-8?B?cHJwNzk0czhOaG5PWGo3SGlGZzM5b25mSDIzaUdMbkZ6ZnpEbGc2OEQrWWhU?=
 =?utf-8?B?cGNMcGI3WGlvQ2FRQTdSK1E2N3NTWVYraHEyMk5nR0NWZXk0NE5BTk5FK0o4?=
 =?utf-8?B?MU9mVlNWeGdWOWNTdFlDMExGejROTVBES3loSU43YzZlcU5kSXk5ZFVhZE9K?=
 =?utf-8?B?UlgvUjF0aUxGVVBBdXkwUDRoTEFwN3RDVlY2cG5XM0JLU2UvRzN2K0tlZXBS?=
 =?utf-8?B?K0tTRENHeWQxd2doSUc0dVRLeXZKRHp6cGNQd2M1dE5DNXJSWTEyeFVHd2VZ?=
 =?utf-8?B?QmpHNFMvTVJhSFlNQVQxUEdLVkIzajhBaUwzbllpaG91Z3l5RXlZQnRSQ2VO?=
 =?utf-8?B?dHhNRi9rdUFGZkl2QzlsUmhsQTNMRmJ3aTlJRmw3dnR4Q0RDMllqWXRabEF6?=
 =?utf-8?B?Q3R1WWs4UVNJeFgwRmZoN0lFSE94NDgxdEZlU3RZQVhVTEFEb2x5SDVmOVFZ?=
 =?utf-8?B?RW9GUHVoMzlaNUZnL0dQQWR5WUF2VGV2ODhzTnZud1B1ZFNwNUlwYnA1YmEy?=
 =?utf-8?B?Zlo2YjkvNXVPL0ZVdkVBWUZFZE5mQ2NFZXFENis0MEkzbjgwRmtOZHF0L0Nt?=
 =?utf-8?B?dFdrL2pVN0xRS0IwTkppckJhVkNQNVBFL0g2Mjd0RG8xV2xVSHk1WUh6Y0Vk?=
 =?utf-8?B?akxCRzJqZm1PMmprQmUyb2Jzc01WUXY3eGIxQTFFSjJoUFVMT1JNUkJ3bmhm?=
 =?utf-8?B?WXpDdm9vaThOdjZ6UGg5a0Zya0VKQXdqQ2RmY09PVXE4RXNYYmhOVW40Mno1?=
 =?utf-8?B?UmZjcSs0b0ozOHhvZHNOcEhiaER4bkdWQlRHb2JwbVJvZm0xYTNWbGZMbCsy?=
 =?utf-8?B?elcraElEUmh0SXpIM2VVL2xLV09NZnY4NFN5YndVNGsrWG9PblV2aHBaT1c0?=
 =?utf-8?B?M2NYSzIyQVoyM0dXb2NqWjJGNEJOWVVzYXRTSlBFS1lkOXppV0lmNE1TUG9a?=
 =?utf-8?B?Uy9QUU9wSXp3NnVsZ3Z3NGhCMTk4NGpjV2c0Zm5qcXJiSXg2emZjTEk3QWNW?=
 =?utf-8?B?Ykc4dlhvTWttdlJhdWdyc2dGaGRrbVFNaGxGYXlHUXp1c2JzWHduQkJzd0J1?=
 =?utf-8?B?d2FwRjdrazl3Qng2SU9kT0Flc0NxUGd0ME5YTXloaVExelBGUHlaQ2VMTWpp?=
 =?utf-8?B?NDhuQis4UEtZVnJKUHFNSDExWVdiZ3VUL01wRE5YOGFtYnlFWm5yeFJxU1Rn?=
 =?utf-8?B?S3NaQVYza3BnNGhhU2ZOTEw5RHIxWkR1eWJkb3hDdFZUd2pkWXJVbGZmckVI?=
 =?utf-8?B?MGlTOXpoUFdnejBzd2EzNExEWDAxV0o2dlVPMkFlRkZpWU5XS005UWJzNFVX?=
 =?utf-8?B?SlFJMUdNMUozN0xVNloyMzV2MHlNZ0dDMXV4MVovNWdWUnZvb1VtMDBuSGpu?=
 =?utf-8?B?ZURYQ3N5aDZUaWlTWnUreDZ4b0kxV0lzSXg0azcwUzBIK09IRWpDckhKVDJq?=
 =?utf-8?B?UFVFQWRaOFpPYnNHb2RRSi9DSFRoRFhpTWJ5SVFObEpsQ25CRGlPRGdhSEJN?=
 =?utf-8?B?SlN3OERkMHA0Y2RFTE04V0VMYzRUMG9qeFQzZURLb3FLR3hIVkgvdWY3M1F1?=
 =?utf-8?B?elZ1dmNhMk5PYituUG5rTGRrVGk5U3JTYThWL0htTUVDVzM2SHZ0bHdKdS9Z?=
 =?utf-8?B?UEdSbExzSlQrbTc0bXFpT0hHQzZDbmdGZkQ1OVNZOGpHc1Nsekx2SVpxMXRF?=
 =?utf-8?B?ZEdpeGUwakg5QkZJZWRwTTQxanRIWXpBVFBGR3R3SXVHRTNJTm9Bdzg4TkhE?=
 =?utf-8?B?QmlveGFZZGlpdWllZDhpaEk0VkVpK1NKWUlLTFN4elltemZRZG1kZnc2S29m?=
 =?utf-8?Q?LOldul91q8kdbHoFVDOCupQuN?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c61e1dc-a6d0-4c68-b3aa-08ddac2e5c3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2025 17:02:07.2273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd1ff30b-4659-4018-98d4-c7ec5f672515
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jZjzpr+jVQZI1hH6i1ke8BJz9XZjlN8kO5x61MLtC/lH8OkeU5G5Ys5H5a+4URc84dmLP8ndYAKgi7PVrKa47w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR05MB8064

PiA+ID4gPiBJJ20gbG9va2luZyB0byBzZWUgaWYgSSBjYW4gc3VibWl0IGEgcGF0Y2ggdG8gZml4
IHRoaXMsIGJ1dCBpdCBzZWVtcwo+ID4gPiA+IGxpa2UgdGhlIGR1cmFiaWxpdHkgYml0IGZpZWxk
IGZvciBkZXZpY2VzIG1heSBiZSBvbmx5IDIgYml0cywgaXMgdGhhdAo+ID4gPiA+IHJpZ2h0Pwo+
ID4gPsKgCj4gPiA+IFRoYXQgZ2V0cyB5b3UgdmFsdWVzIG9mIDAtMy4gV2h5IGlzIHRoYXQgbm90
IGVub3VnaD8KPiA+Cj4gPiBJbiBiY2gyX21pX3RvX2NwdSwgaXQgbG9va3MgbGlrZSBkdXJhYmls
aXR5IGlzIGVuY29kZWQgd2l0aCBhICJiaWFzIiAoZGVmYXVsdCB2YWx1ZSkgdGhhdCBtYXBzIHsw
LDEsMiwzfSA9PiB7MSwwLDEsMn0uCj4gPgo+ID4g4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC4oCC
4oCC4oCC4oCCLmR1cmFiaWxpdHnigII9IEJDSF9NRU1CRVJfRFVSQUJJTElUWShtaSkKPiA+IOKA
guKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAguKAgj8gQkNI
X01FTUJFUl9EVVJBQklMSVRZKG1pKSAtIDEKPiA+IOKAguKAguKAguKAguKAguKAguKAguKAguKA
guKAguKAguKAguKAguKAguKAguKAguKAguKAgjogMSwKPiA+Cj4gPiBUaGlzIGlzIHByZXR0eSB1
bmZvcnR1bmF0ZSwgYmVjYXVzZSBpdCBsb29rcyBsaWtlIGlmIEkgd2FudCB0byB1c2UgUkFJRDYg
KHJlcGxpY2FzPTMpLCBJIGNhbid0IHJlcHJlc2VudCBhIGRldmljZSBhcyBoYXZpbmcgaW5oZXJl
bnQgZHVyYWJpbGl0eSBvZiBSQUlENiAoZHVyYWJpbGl0eT0zKS4KPiA+Cj4gPiBJdCBkb2Vzbid0
IGxvb2sgbGlrZSB0b28gbXVjaCB3b3JrIHRvIGFkZCBhIGZlYXR1cmUgZmxhZyBgQkNIX0ZFQVRV
UkVfZHVyYWJpbGl0eV9iaWFzX3YyYCB3aGljaCB3aGVuIHNldCwgbW9kaWZpZXMgdGhlIGJpYXMg
dG8gdW5jb25kaXRpb25hbGx5IGFkZCBvbmUgdG8gdGhlIDItYml0IGZpZWxkLCBtYXBwaW5nIHsw
LDEsMiwzfSB0byB7MSwyLDMsNH0uIFRoYXQgd291bGQgc3VwcG9ydCBldmVuIHZlcnkgbGFyZ2Ug
ZXJhc3VyZSBlbmNvZGVkIGFycmF5cyBhcyB3ZWxsLCB3aGVyZSB5b3UgbWlnaHQgdXNlIHNvbWV0
aGluZyBsaWtlIFJTICg1Niw0KSBmb3IgYSBjb21tb24gNjAgZHJpdmUgSkJPRC4gUHJhY3RpY2Fs
bHkgc3BlYWtpbmcgdGhvdWdoIEkgZG9uJ3QgdGhpbmsgYW55b25lIHVzZXMgc3RyaXBlcyB0aGF0
IHdpZGUgaW4gYSBzaW5nbGUgYXJyYXkuIEF0IGxlYXN0IG5vdCBmb3Igc3Bpbm5pbmcgcnVzdCwg
YnV0IGl0J3MgYmVlbiBhIGxvbmcgdGltZSBzaW5jZSBJJ3ZlIHdvcmtlZCB3aXRoIGVudGVycHJp
c2Ugc3RvcmFnZSBhbmQgSSB1bmRlcnN0YW5kIHRoZSBydWxlcyBoYXZlIGNoYW5nZWQgd2l0aCBm
bGFzaCBub3cuCj4gPgo+ID4gSSBjYW4gc3VibWl0IHBhdGNoZXMgZm9yIGltcGxlbWVudGluZyB0
aGUgZmVhdHVyZSBpZiB5b3Ugd2FudCBtZSB0byBzdWJtaXQgdGhlbSBhcyBhIFBSLiBOb3Qgc3Vy
ZSBhYm91dCB5b3VyIHN0YW5jZSBvbiBMTE0tYXV0aG9yZWQgY29kZSB0aG91Z2guCj4gCj4gQWN0
dWFsbHkgdGhlcmUncyBhbiBlYXNpZXIgd2F5LCB3aGljaCBJJ3ZlIGRvbmUgYSBmZXcgZGlmZmVy
ZW50IHRpbWVzCmJlZm9yZS4gV2UgY2FuIGV4dGVuZCBCQ0hfTUVNQkVSX0RVUkFCSUxJVFkgdG8g
NCBiaXRzIChzaG91bGQgYmUKc3VmZmljaWVudCwgbm8/KSwgd2l0aCB0aGUgaGlnaCBiaXRzIGdv
aW5nIHdoZW5ldmVyIHdlJ3ZlIGdvdCByb29tIGluCmJjaF9tZW1iZXIuCj4gCj4gUmVuYW1lIEJD
SF9NRU1CRVJfRFVSQUJJTElUWSAtPiBCQ0hfTUVNQkVSX0RVUkFCSUxUSVlfTE8KPiAKPiBCQ0hf
TUVNQkVSX0RVUkFCSUxJVFlfSEkgZm9yIHRoZSBuZXcgdHdvIGJpdHMKPiAKPiBUaGVuIHdyaXRl
IG5ldyBnZXQvc2V0IGZ1bmN0aW9ucyBmb3IgQkNIX01FTUJFUl9EVVJBQklMSVRZIHRoYXQKcmVh
ZHMvc3RvcmVzIGZyb20gdGhlIGxvIGFuZCBoaSBmaWVsZHMuCj4gCj4gQnV0IHdlJ2Qgc3RpbGwg
d2FudCBhIG5ldyBvbiBkaXNrIGZvcm1hdCB2ZXJzaW9uIGZvciB0aGlzLCBhbmQgdGhlbiB1c2UK
YmNoMl9yZXF1ZXN0X2luY29tcGF0X2ZlYXR1cmUoKSB3aGVuZXZlciBhdHRlbXB0aW5nIHRvIHNl
dCBhIGR1cmFiaWxpdHkKaHRhdCBkb2Vzbid0IGZpdCBpbiB0aGUgb2xkIDIgYml0IGZpZWxkLgoK
RG8gd2Ugd2FudCB0aGUgbmV3IGZpZWxkIHRvIGJlIGFkZGl0aXZlIGFmdGVyIHNhdHVyYXRpbmcg
QkNIX01FTUJFUl9EVVJBQklMSVRZX0xPIGF0IDIsIHJhdGhlciB0aGFuIHRyZWF0IGl0IGFzIGEg
NCBiaXQgZmllbGQgd2hpY2ggY291bGQgcmVzdWx0IGluIGFuIG9sZGVyIGtlcm5lbCBzZWVpbmcg
MGIwMSBhbmQgaW50ZXJwcmV0aW5nIGl0IGFzIDA/IFNvOgoKTE8gICAgSEkgICAgVkFMVUUKIyBl
eGlzdGluZyByYW5nZToKMDAgICAgMDAgICAgMQowMSAgICAwMCAgICAwCjEwICAgIDAwICAgIDEK
MTEgICAgMDAgICAgMgojIGV4cGFuZGVkIHJhbmdlOgoxMSAgICAwMSAgICAzCjExICAgIDEwICAg
IDQKMTEgICAgMTEgICAgNQoKVGhlbiBhbiBvbGRlciBrZXJuZWwgd2lsbCByZWFkIGFueSBkZXZp
Y2Ugd2l0aCBkdXJhYmlsaXR5ID4yIGFzIGhhdmluZyBkdXJhYmlsaXR5PTIsIHdoaWNoIGlzIG5v
dCBpZGVhbCBidXQgSSB3b3JyeSB0aGF0IGR1cmFiaWxpdHk9MCBtaWdodCByZXN1bHQgaW4gdW5k
ZWZpbmVkIChvciB1bnNwZWNpZmllZD8pIGJlaGF2aW9yLg==
