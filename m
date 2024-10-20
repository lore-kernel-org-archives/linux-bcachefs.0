Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E1CEEC5
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 11:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729424754; cv=fail; b=HtYTBPlyP7QrIkIlidL3/fHcWz3cq9LlZ3h8krmXg6N5f/es6C+xOXP3MbsSS58n542QfLYcyO3J9DTWIvSr1Xxi+2SpUa81wtaTgRcDayFxhwB42YFo9+MkcDc71cafGXOhzoy5H7TD9mq9MNAPnSYz6Ltb1OCnVai4Rgh+TUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729424754; c=relaxed/simple;
	bh=q+V25yQcEAwjijjz3quMcKucK2QY2vMsGCdR4aqdzKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JYdh8S2HH1/DI0xhcEtn2K6G0vpK3MfC66kV15oIkKbyma8g4lrhvc2CD4mxeuU1O9H0QVHLLegLjKXrjI2JUlbutoDFyQl4EqxAR0iOQA/FXfx503a0OViLZ1f/OcF1fR56TYyFcQeHY9UzFiT8dRgGx2Ruuci+G9Vy9WMVa0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CZcEbCUE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qp+DR8cc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CZcEbCUE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qp+DR8cc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49K31oCs026193;
	Sun, 20 Oct 2024 11:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=5nWc+TLGoK9V9yT4Xb
	EY/U1lSSDFVj6ucbe5BsNHIrg=; b=CZcEbCUExwcKFNioE+T9lDjRFf2qpRAyza
	72OZvK3kledDUqZMAE/a9UrUCnQ4RSx/ao36zxNV+kLBPMEB4n7ZiuzX/Sp5VNPr
	ah3o3TB42M4A+b+EHAXrZMjMV6EQ4VkkxO8KxdLjFzX2/NjB8GGIjb2gN7BiNQBO
	5qMj2Ble8WqMToClYUyzZl4VM6jbEf+/JMFM8NATzXmV+dIHjdKkH3qlKeHLlWQM
	BWFNozFzTMbXnI0kl/dqczxPUjDjEXSeeiy4UDPk+IRKLi7EcZ/iMInAKNy1UgAt
	10+soXiFcs+gBykt8vjkYtujCGEggWyzOTH9shXnGhfcbEpq8z7A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c5as9fer-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Oct 2024 11:45:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49K9O7FB008299;
	Sun, 20 Oct 2024 11:45:39 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42c375cpfv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Oct 2024 11:45:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L7hIEH+Fg0GC7Aho9VCiIeND1yxocn+gNwnh1t+7sqPh+TGwyWAwQDBt1FZKnILKBR4xGYfWGCRj73xnnnF72rHFx/vEU0g0/Mqv37SOZ4dXjjru3aEajRYriEa9B8VG1WZMDx5pwU/K2f3P3dHgVpaV+SIW/MqmqOyRUCKPtSzqoyMZzKHU+lw60AXoB/V+gQzeA6kSI6g3Nxw4R0Z1brH3r01PbASZ6HklZb6/QSey1qRbihrBp9GNnRfdGRbyLNc420qT8YmA7qLJPe33gVLh11mQb8fYu5qAfszdIdIwUD93lRLE1snUIR4F+7RRaiC3Y9opcBzKh59U4C3iYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nWc+TLGoK9V9yT4XbEY/U1lSSDFVj6ucbe5BsNHIrg=;
 b=ETvdu3255vwnJO95hOfCykwXoqgH7R7eeBRqprtihlX2xlDxDhzBlPjXI6C01CTAcPPX9HLIxjPlrlvM9Nm5YzWKCgHpMBEgby2TciLorkkMtoai7LdRKCHrDVKPp6meUhIfWUBeC6PqhaVwTv0aUjH8aYO8nURt0nWocs0BZslTaypNbuQ660w6T/3UWPedSgJ5WJ52/64+3b2IjMsyQeP6ok74k05pXF7OtMssJY5zxzlXa6iC2GNlYhV+chpkoI/h7y0fyVO+4+8n5m3MG/SjY2Hq4A5TmEa7PSkbSooUsd/00Li3g803li4SmZWoDXG/GuqvCf/LKZBE742G2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nWc+TLGoK9V9yT4XbEY/U1lSSDFVj6ucbe5BsNHIrg=;
 b=qp+DR8ccBHO+YxmCR8A3l9bq5v1wDKCcvVdI2zkLaftM3wNZMD8tCWpUNGOK5D6V+oTAfcHxaZz7Ox/Oe9jXAEsGcFUA29LwKDmceypxgVvZURUo/Nssb8BIrOMryt/XW3gySZF5yu3UapsFgZdsZJGMEbYgh6HYtTzYsUgYrlY=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by DM3PR10MB7911.namprd10.prod.outlook.com (2603:10b6:0:1e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.27; Sun, 20 Oct
 2024 11:45:37 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%6]) with mapi id 15.20.8069.024; Sun, 20 Oct 2024
 11:45:37 +0000
Date: Sun, 20 Oct 2024 12:45:33 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241019210037.146825-1-kent.overstreet@linux.dev>
X-ClientProxiedBy: LO4P265CA0126.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::17) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|DM3PR10MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: a461b0a5-f6c4-49a0-db3f-08dcf0fcb657
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lsP1gdiqVzhXSePvh2qMXqafZKP/ePgSV9wWyw/lnoLkmmA6E1Gid2f5UdeV?=
 =?us-ascii?Q?hkzMXxe3p/9c5Vt+kwfphdrau9cDs0kbfBwg4XxtcqnHrwGXuzUUGdofN3Ho?=
 =?us-ascii?Q?W2blVQ7ysJZS9BJOWNJjUCVAanmY/Bf6VQa3X4nGWFLwHmSfOduom4kRcwAq?=
 =?us-ascii?Q?pm7uWmn4+vlgpvRCXokTllbeXo9quKFEJ47VmfTxh5JOh/ESahrqjRE1GbJg?=
 =?us-ascii?Q?CKfc4hxbDZxQHH+rmy12VPNOFYhnFqALGcFqhOuTwBZqliD9r3VERuKiF4wX?=
 =?us-ascii?Q?yq7Ur66uZGD5lqJf1l3vxd3bNHdT9hNdGBTwWRHH8C8TakzKjc0qpjXNqpka?=
 =?us-ascii?Q?CsgBcDcoJVt4/lVcJTTm/VIzg/gjDP3lePO1RHGfrnHB9lL7PZG9mNMRHev6?=
 =?us-ascii?Q?XMfV/g1LEiz6iBsFd717IL5WT1+e2fDwxMlEmQTzCxyQqddyZgxkFy9Q84PE?=
 =?us-ascii?Q?/0x55BuumC4/XfMfm8XbvE5Mqql/v5uw/iXqwOlPAQK+p/YM5CH6BdLXrw1I?=
 =?us-ascii?Q?/4/2cOf6FnBiHzc1kKoAmHCixJ5Ly8vfDIqMtOTWYHK8/fPZsKkFY2P6+P8c?=
 =?us-ascii?Q?q9nhCgv1SPaLL9yBLVK1Ly8rG8Rv7GCHpOlPwfobL3LH7aIuQHr5wKiLXy94?=
 =?us-ascii?Q?+pCDRRopreKh2Adjg4XqHH/pYmLvbAFNTgKlm3Ou4eZZqxJ7d6/qa/6DiJUg?=
 =?us-ascii?Q?im4O3Nm2AIaQlB77us/UAJztxMSTYTq3uSZOJ9LWYFWWF7JqVShkOJDYnYCu?=
 =?us-ascii?Q?V5i/YduOW7KI67Yiq+Z0iPrziYwktFnUqw6mMEIU7wROcHkYQfi+PIrgeP0G?=
 =?us-ascii?Q?Dcv78gHF1FOFFZYos/M663x1uEFjrd4U9F8KEqPqfyp9Js/g8nK4kc/rtt93?=
 =?us-ascii?Q?iwWnhtoSlcctgYdGbnyXxR1jRyKAP2PyjaODplkVFAO5XANkaFEVdD2ZkH46?=
 =?us-ascii?Q?vJg7uYX+YN34mPMmtFgGdolwxAZk0R51njGthscVpPA204mtBn2H722Qu7zQ?=
 =?us-ascii?Q?jljLBPF3lZziuOoE8FfO0dVQnzNsG8YpRNA7/S8G8crbz2tt+jrN3BRJT/Zp?=
 =?us-ascii?Q?fWzKAc/T/a787JwFCoVDiQmKDHy0RKnNEWkUGsD2t4tmTVCr7iHxwLjAh3e6?=
 =?us-ascii?Q?H7VhkSrVgZmCBqwr9mFmHMxJHGMGhDnx/2KiRMy0sDGJwL68SoszAhsRottA?=
 =?us-ascii?Q?P3Te9zYfdkgKqjD2JyyGWU1r1wW7uQ2tPLQRKqWncptVgTFUItN2iB7vikDW?=
 =?us-ascii?Q?nUUphyIDQpu7ozX8RwJo7nJLU9WeAypyFh4d3QsZbaQ14pO+M/ILLl8ldoe9?=
 =?us-ascii?Q?pV/3teN3DBrTzRl/I2lkEYSj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/PRAPiXHafyZJOvO4w0rDxkps2iUHdA8Ks242KB1bLNshdRgha3mEsNLXe70?=
 =?us-ascii?Q?Ybd4h5mIrdGSNRIks+Vk2JuXPOw5mPi9USVrprdN+DZGhiXJma+w3rSjNbCw?=
 =?us-ascii?Q?7DmjK7fYJOzIaP3xdxp77JIkwVl5tqAUTPpa0Qa7rf82ahtskYisppqWKHjz?=
 =?us-ascii?Q?JS1mrtUra7RYFZXQ8YUwEHhA9zRv/K4O1VPXKXAJ5ZzkVDD0DcT+t8livKeK?=
 =?us-ascii?Q?j2xW/Cx8R0hmz9QlQUgWfPeB1W6ntEa3ENsfNFdgcO7IT+y/oI46QkSoNYsT?=
 =?us-ascii?Q?GJ5DBcFK8/va3zB3tPHpUf9IWLEuX0Jhc2i77Mb73eTGXZx43zBTmTyJUH3w?=
 =?us-ascii?Q?nXwdLJ6VPHka05Vv7wGyxSMexD+dc+Tg83HZgXlcSNxlm/OkFDwA3bsiiSCZ?=
 =?us-ascii?Q?spXCiZZXbu/uFCj67WCuCMoEYdxkAhaOOrjtj99/JOQiWNcNc4jpUEgkyJfD?=
 =?us-ascii?Q?pPwpoXBs+381Nf2353+RqdqZTr/JG2IgFlVVGQEJcBO/uFtD1P88ZeXVUMeh?=
 =?us-ascii?Q?inykzblZ9tQI61a70AQviXPKxCWPbjWJjnY4YxBEAHDFhICsmntqy53QQvGw?=
 =?us-ascii?Q?AbaDcJ7dqjhnV4cL3bIOXRWLzNWHlgwLa3MkB79ldaV5jdd00Z7LzWi6qpwS?=
 =?us-ascii?Q?pV7Ogsid8h9W8OwCDBoC7JNUSbOFiG8VHeos0QMHmaqQsyzmxZAfMBe20TWO?=
 =?us-ascii?Q?TrNAnLGJTbntDWA1OOP6B4g/am+dQTmuJssqPyPQeIbpGDVf40gDyUM/pfNQ?=
 =?us-ascii?Q?9QSAfkBHNSQfmN9EVNK0ic/SeizIZgZeAjamSZxg2Ni/MhC5s6HQyXE5Mbjl?=
 =?us-ascii?Q?gyBQtnnst5MIkbu54SaK7mGThmd7/dyQ1NxHYw8nNPVbe9ltz8OskgwKzQh+?=
 =?us-ascii?Q?MF54xegd+in0VZCIk6JEjS+mUF+rJd+Yqv1h/QhmylPQUl9ZPi5xWZqcJ7Yf?=
 =?us-ascii?Q?R/cf+0fespckRbzwXYuYfBEbu5RlzU+gxm1F2SeTp8GQmvDfj1MMoQrIAPmh?=
 =?us-ascii?Q?+E8dT02NXhPrRDddMhdoIRx9HekWHAouYPZAsFs9SQzN8aU5EZF7JRvfTOaZ?=
 =?us-ascii?Q?YjL6dSvggNuyt4FtPlAV0FmNE2wpgvh+lC7FLG4pthxWCUIAd+oHZXGE2r1I?=
 =?us-ascii?Q?SSLS08wD6LLWqh0pzHPKkoVxec0AzINKxHQGmGQYmtLXtXR5PBUbihmUmp9Q?=
 =?us-ascii?Q?JR59jK/iwG4ENlFlLXyA9Ok6y+A+0Qyf8g+giLNM8RxssEGr0Z6IbgQTdZ/J?=
 =?us-ascii?Q?/sEosfj/8dqP/WY9HZbHRQJ+VSCLqjEJCw8v8NIwzfT+9xgCQh+MtVshYnVW?=
 =?us-ascii?Q?OuN6ex/d6CjPZc2itFVsBGdm7FV2PSeJIED5jRnnLaH0dg7aERQrPmCln4nP?=
 =?us-ascii?Q?13QwBthhzTms4SuL0Pjr//AZLOe7D8fmyXbf+jpFR1uq5vQJPAzvGj7J20oz?=
 =?us-ascii?Q?1PCT0EnJu3v1UBZPvgPIiplgF77SxFj2KZVQYLhmTe3ydc2bCcAcXcj5YOhi?=
 =?us-ascii?Q?pkeuOr44PqnUcjty65CAJUguQQo4+vUbGFA89DwlLHgeBSlYJR6L1Gx74ZXY?=
 =?us-ascii?Q?TttXA6WvqymcM7ZAe8pTmNrtw3plg2yEclPZaIMRxz6opAEwcgCgGx8aOTWu?=
 =?us-ascii?Q?/lKPuhZiSflRwwU7LU/XvClBSJDNoXS+8h71HDiSAAoeEGuBPEDUukaWUaLD?=
 =?us-ascii?Q?ScJaZw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L3Wn74jRtLg7WyykEZMfZ5ro1syXjT4PzZZQnPDrjG6JewcS/tX7zdS5FX2vPqMy0ruln44tO7ajJjjOujhm9InmVmDUS6tCUGuuRx4atFyPhTlAFmPksR3QxfVcbS18xX8CLHk99+VAAxeFWAxB5mSceEq9QMeR6ObeIf+/qet+vix4j5uUBIw1ZMH17ISzbtP4X0mcOSQcCMraFRhoKQychpw8CktoG5xTRkLBElvJxkrXLuzMLC5ALhqoSho2xAXrS9hSg6A/H1q3mXh38fkmFvnmPJCXY3dDR5PRavQCeV1RsFFSsRqTejlTJ+yk0MSKcYuma9mdnODX+n0asFr+dOZMavVhA/k6XofcmeRrAudU8k4sFpQOuJyd4mJr+ejkPSXLiDEwh7x6gsc8OaSbnWk9kvtvzkTpTpczYZDm6NpgVua2ku9t6+yHG/MHoN0d0RV6YKbl4nIKibQld91fD57WvSPZSnvgVFkGTPWq7Hs6jN8MnckjtWZyB2bWT41UWtgzdPoxWQQ5CpYgUBe9IPFA+kxgOW4muE9J/jkb3H42csyw2//bnDD0Rko5LkF7nBSW/b9Uo6Spzb8SLYKNAlIsX85ndcc5O+XO3SI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a461b0a5-f6c4-49a0-db3f-08dcf0fcb657
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2024 11:45:37.0614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dOY97GEAMy82Z0b9x+7gmzftdJWxJY/4l38EqVqyKbzV3QwzP0NNhOiw6ThlPbPNXg9YGzezrc4yJaauPh9dD0op6eqUujxudMGDIbeBHKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7911
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-20_09,2024-10-17_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410200080
X-Proofpoint-GUID: S_UbhOVB1kKNTY8ooimgiGrvcDAwDQfv
X-Proofpoint-ORIG-GUID: S_UbhOVB1kKNTY8ooimgiGrvcDAwDQfv

On Sat, Oct 19, 2024 at 05:00:37PM -0400, Kent Overstreet wrote:
> A user with a 75 TB filesystem reported the following journal replay
> error:
> https://github.com/koverstreet/bcachefs/issues/769
>
> In journal replay we have to sort and dedup all the keys from the
> journal, which means we need a large contiguous allocation. Given that
> the user has 128GB of ram, the 2GB limit on allocation size has become
> far too small.
>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>  mm/util.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/mm/util.c b/mm/util.c
> index 4f1275023eb7..c60df7723096 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -665,12 +665,6 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
>  	if (!gfpflags_allow_blocking(flags))
>  		return NULL;
>
> -	/* Don't even allow crazy sizes */
> -	if (unlikely(size > INT_MAX)) {
> -		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
> -		return NULL;
> -	}
> -

Err, and not replace it with _any_ limit? That seems very unwise.


>  	/*
>  	 * kvmalloc() can always use VM_ALLOW_HUGE_VMAP,
>  	 * since the callers already cannot assume anything
> --
> 2.45.2
>
