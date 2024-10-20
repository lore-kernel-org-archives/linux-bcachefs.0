Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53979194AD6
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 16:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729442705; cv=fail; b=THPe41wxF66VbmxBlq3YdNZDrv2ZWzzMdYoGYOkuoXf++Qugkv/VQLyILjnbuQqSvhFWQ7YOhI6jsbe3zm0BtF0f8WQj+hgKF3cOlAnqa4a4oSxJqFX2GLCEtVa0GBuy0CRTAktg/aE/rlHTVLPy522KbJn/lbii023lIgypL0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729442705; c=relaxed/simple;
	bh=9AJ8A8Xl8NqRwyycfvsk6+TP2HoRjUnlCnaSqROWTBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gFfMzbP3wd6GcuNVfCMfQu4tX2tyIYYYBlRuodQZ4TqZRaop7iNJ6R6TJGUeeUgS0SmCj7BX1/2deQ69BIrkPWQewWuar9cKLzWr5fAuHnjFD7ElUYGWXJargKWj6rU4hg45C+ToRBOKaUFfurxbalJQbJPcAF5gkSiTUKr0r90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ag/1y6kt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GeiNg0s8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ag/1y6kt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GeiNg0s8"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49KDBjkP028098;
	Sun, 20 Oct 2024 16:44:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=VvccvPelQoYa+dEfm4
	s/lnmtwtbehOD0umxkL5YIzas=; b=ag/1y6ktA1uLUpPkFVv5IE6FGHjsdMrZv5
	kGk/CQacDLiLBH8qfCyutAD0Eh/1IydZXzq4lx2xjhsCPWsE4g9Qi8SjjLzDFirs
	aGBZ2iELYDXTOONa+RUHwb9GkZrMh0tlu2DKtRMdM0ebVQAxtRcsO1vZHiNPklMq
	eUB4d2lnGJc85vW2PpP7zhFNsi87E5z2PstJ8iZCSuUVNXoJnMjj2+hDhmAp61r9
	VVzoPtBNcwYqLQ0BkubuPNjU+L5bs/dGGNSXD7V+djGqwoeo+RnbTT7jAPDFLv1e
	EbD4IOlQwzZKqcGff6TIwttIupvfHO9vVZijOd7KUSxkJzdKpAxw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42cqv38xre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Oct 2024 16:44:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49KDoqZe007594;
	Sun, 20 Oct 2024 16:44:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2042.outbound.protection.outlook.com [104.47.55.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42c375h2fe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Oct 2024 16:44:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UJBvhW6bmjd6AM5J/ZVFEGvOmmxpjwNpZNE2sO7kA3gy0yU2y6S96s99m4zt+LbIOHxD9OWyV90/XJPzfmH2izFnZCrW7YZuvrLZNAdOWcLCDbcwC3KEGmryaexz5juENHY0mPLadvnV5iCxK7bEg0L6QwqhJxAdxjdHm3Qywd/01VtK/5no6hLzzBiOluXo6r8oHZNfyGbQsjoiDy+DOMuOfvk4GKzT/nP1LAKmm73kX/gnh/1uaQ0+Nh6sU9XpcEUo5N5zX5C4PagALRCSRG33VOIYk42MbjflD+4tX+SaVYR0x4/nsrL73Hz1amVr5dnYNH1PNUTPhqgjrYy+7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VvccvPelQoYa+dEfm4s/lnmtwtbehOD0umxkL5YIzas=;
 b=XZNDONKdL89hGQbNt234pd7Qz/sF4CvOX9Smey7ErlaEejizX3deU095Jzb0ttOytzpgAZfRlVq0+zodtAqboFkqD9DUrxpPx44389cZpe2cw8JhJFlYq+REkkc5atosJo0yrZEv9QE70Pvdtpqmhll9vAJI5fnQpcMKtGEEmAh9tdVUkXbJ/De/o9swnnfx7gvusuMvJZvqcAJUQdZtlJqqXRH5hHRKo2mpar6mgqGQX0ku4W5Cv22R51kCtDAW49mNTpt8uNEHxv2KxDekiu1LKaO+dVCuX1ahfMulGBMwUqZjSkFRDtzveV241NdlSbJLRIw1cyOnevqNH5Kvog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VvccvPelQoYa+dEfm4s/lnmtwtbehOD0umxkL5YIzas=;
 b=GeiNg0s8HgpwiaOwCx16sS2eKv8Qy/o/njeigKESuHQZed1kc8LWgVIJEQ7Qr50XZoXnAWdgJTBAKB8bbz+NVxKF+ZWnH05OD5HVU/GKbcnabGg6AmcdCBcaWov7Ia1IILUyJ7pD1bnLtHdWZEqMR4lpQXctWgHXmihcSun7jro=
Received: from BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25)
 by CH0PR10MB4827.namprd10.prod.outlook.com (2603:10b6:610:df::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Sun, 20 Oct
 2024 16:44:40 +0000
Received: from BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9]) by BYAPR10MB3366.namprd10.prod.outlook.com
 ([fe80::baf2:dff1:d471:1c9%6]) with mapi id 15.20.8069.024; Sun, 20 Oct 2024
 16:44:40 +0000
Date: Sun, 20 Oct 2024 17:44:37 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
 <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
 <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
X-ClientProxiedBy: LO4P265CA0210.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::13) To BYAPR10MB3366.namprd10.prod.outlook.com
 (2603:10b6:a03:14f::25)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:EE_|CH0PR10MB4827:EE_
X-MS-Office365-Filtering-Correlation-Id: 24d8147b-bcea-41c1-2d81-08dcf1267dd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ajsCP3a3EBrIO0pVvQzAI9wQ68JeSWX6n8uHlG+iy8MXfKW+h4p9uLkP4RjG?=
 =?us-ascii?Q?wGwUHDfQnjGncjcYWRbYyI0bKtzW/N1oAbzqgDkS04SeNL7N41ZgmIhJfBIA?=
 =?us-ascii?Q?CIBQs/m8QP3akYHdBYmnnn3mXAGuCQcIfqN9QRTzP4FA6qatquSzJsQGM4km?=
 =?us-ascii?Q?kbsfPnwjvUqSh6vofyABU4T1Y2EBPVD/+0bYhFLpFbG2mpcmEZtF/vhVCoWT?=
 =?us-ascii?Q?J4pyG3RYaROcfClysUigNha/3Ia3ajZXYGlTndaMviBrCS+QWtnN3/RV8u3P?=
 =?us-ascii?Q?ycSdeFeKXFN4Vz20RJcVzSatHjT7nHnFKMaDE8INQn3p9c2YZ0YPQxkmW2VY?=
 =?us-ascii?Q?2T+iKQF1r+W2zzI4kp8FkJe5pLuzhai7RUsVQ3RS4sLtkM2LT5ZkhHjr0s5m?=
 =?us-ascii?Q?EDaKPCONZ/XB+mU2yCM+OxOWcSNFUtsdG2CQc7RXszkbPbPXLpp1uvK885za?=
 =?us-ascii?Q?IrQKf3gdkq77JV8UAN9hfGYjrQZulU1cwd1pIUyBL24tb3gVYdlGcReBVQ0K?=
 =?us-ascii?Q?dGaTRBeMUIRdZt1jwVsVfoN6tJmoJr99NaH2StupgpaURnxw2hi0dCcYGXlP?=
 =?us-ascii?Q?3ZA/SXHsptQm3MglUn1xzPP3POCU1xh9BPa5GqeLbGJ2bBI24yEpr+yacbZ/?=
 =?us-ascii?Q?5xV3sr2fnRI5evtEmd314vQBocibsK2id4wFIUez+Qkd4U84ACDZ55etHMFc?=
 =?us-ascii?Q?MPuIK6AO90lWMw92aIDtpRqB5I1ZLFbO5YzhSg56mqAf5EmHkY0boqFwN2km?=
 =?us-ascii?Q?pLrkopDclwUbzDMEYoCsrOaiJMjeN9x4TqJxxauO4NV2tUbfh/hb9POQ4FRp?=
 =?us-ascii?Q?ymMZ9GmNeRXsiN+SXVD2fCp3QeGhL4B3HA10l45BE7kG0E8chOQtWPZqlDht?=
 =?us-ascii?Q?5hdkMWd/cfO8zrFqOB3lv5LAaTlQ5EZxgm6FZgGT4/W8bo4jxFoKL5T6rxxM?=
 =?us-ascii?Q?CwsW+DxUUudzfClTUy54j4IVPglKhw7e9LMMJEh4mg4k/zESWDe/5j+V9jXy?=
 =?us-ascii?Q?7IgKtpHA+DNIEyga4QhaSdh6kORNMwMVbK0K6gQMNKUZWqRTIrD1ewzoAhuS?=
 =?us-ascii?Q?W9RKGhhgzr8uCJubGQGzDikWeTIvBmP51YyK8Exn/8COAMQFHgKxnNhbgNxB?=
 =?us-ascii?Q?+TxWnj6faqlwSv8CyY4YXX5JeaJTzywhERQyhIfqT8kk/6vLA+mugUnhm0IC?=
 =?us-ascii?Q?TXPTJol6J5dtca09leZqGs/ne1mOfjQwW2tlGTpd6+XgtfPdXe1RECfbVp2U?=
 =?us-ascii?Q?cPrPHQaTheBEQ7ahJOJ62p4QnnF5bFYoTJvYOiKU2nf9jDc73aIr3Tlr7+12?=
 =?us-ascii?Q?vMB/dBObKckx53dAFHu8J+PI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3366.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6B9YQUF1PH/8NSUL5OcryEOKXHsrZjoaaArfeEbMN9GbybrKu6V8DtYjgxWp?=
 =?us-ascii?Q?jyscBxkVa2pZs1ahSELyXjOSI0y7qYUuq7JVEtXfyXKPod1cHgUauzWUFaiM?=
 =?us-ascii?Q?RR5YzPh+Wz/ZkEh9xtgL32k63gMAnjhEwPrOEeaInXcv6CIyTLbx1CopX8os?=
 =?us-ascii?Q?vq/8N+vq18fcz7VxG/w6jMHfcXVeyzq8qkclkNZ/BB99rjf4+jaC73hCF15N?=
 =?us-ascii?Q?q9CIny3Gg2fRvMsS2yxVwazzuLcueLvBH+3S1lDFj8oW5lxXABgTAulBzFMc?=
 =?us-ascii?Q?lM35M1Je1qdC3+d8rGCrkZZcj4SOeoL8Sbu/GNjA5pJ5Khp53EFeqvjZ19Tl?=
 =?us-ascii?Q?Vaaoggq8HB5H43fcLtD2ay59esjxbDq9XnpXC9ipwgeyClQSdkTDAEjFkib6?=
 =?us-ascii?Q?i5QhSjnqstTXooDKRsYmtY5sDyeUtn3vq7TouL1sjo1Cuh6fSSbIh8Rh4Cu8?=
 =?us-ascii?Q?4R69xTBwqw7hpWuiyzt66hS0z/Ie8g/EMuBAWGMgG8GutmOB1BLQGemnQYgw?=
 =?us-ascii?Q?wQVyYuyepAapUAifiw5zEUi8AKFNcipycUoNpnb1VPYhFKGat4mw12igH0HA?=
 =?us-ascii?Q?YVnVCdDTU6yNN0E3FpYjnp04SV/8HCpyw3T0Ln3BvMpDVonk4v9ubIFh1Pa1?=
 =?us-ascii?Q?pD1syYBNiEhizFD81Ut/qBvwTfo2aGIGZVoj3oBIR7U7Axf4Pk60B+vwxeNy?=
 =?us-ascii?Q?QEZOs5FS9RFD0rceKDIqdsgHmCRqLsfx8PoGj/V8qTMYXG6Mni1RM5k31YY9?=
 =?us-ascii?Q?cdL9mN0jNkMhUPXeT6ttftgkqwAkgumKxxoYBKiPZQ+8BeUOhGrH+jpI4CJB?=
 =?us-ascii?Q?XLHY0kYyRbub92Xmg1alDRU1aPVgZDjFA90XzwBPI6RpYPJFvB+7SEhoxoVV?=
 =?us-ascii?Q?MylhFtTYZNBOBABpCsFlvRaWadZizRhs3VWQrqEcRBW8Y8Iu/WYU/WeLRPXY?=
 =?us-ascii?Q?ZrVszaYpUxt26ar4RDh3nmuCTFlpQ81itEVuna/hRKGD4TFKTR6sPV/TSq15?=
 =?us-ascii?Q?I9H/iCgu1Fz9d4blcpbi2CQAGSqWDbc0GKs3/rLzuUHoey8BlgOMCNCjPI7V?=
 =?us-ascii?Q?EptFTgemHkZoN6WoXce6mjPwP/kH2SIi6gaaq8X3VtOrYJ4xuc6QTySNnrZY?=
 =?us-ascii?Q?9LqCTQjafbEZh6/2YFhKKEuo1+A+mNx0sAPTbocSchis3CNjjiAeTA+dPXY9?=
 =?us-ascii?Q?EPXExm+GxUvWb7HU6LdaNrP9jrBaNGoSKcxkyRMY/viXJkhgq6QXlZ+7NdZE?=
 =?us-ascii?Q?Pa2c4glZVcZ+cCzLOXSBXiDHPQFyRMUDi3bSxePPV/UxEVbwRQs0JALIy7Ya?=
 =?us-ascii?Q?O+Bqp79SOUYBd8f8MYEFab/Abw4Q57Vuz/U8h5R97o3TX4Al/DuOLWeD0k7U?=
 =?us-ascii?Q?lXPUcPa0pk8YX+n7m4ujQ1NQSxzwov8tKbPBUJuHTyjb++f4wQ+Ui2xjn12b?=
 =?us-ascii?Q?DsaBYlP7zBYOpI2qwuUWw0AmhFJyFuuaijQ1c8pNUuyPQG2a+iTPFYXpCwpZ?=
 =?us-ascii?Q?Utdn4SfmE1Y2mMYymf9HFrGRnFBwFm1a1R3OygMkNLw1CozXEA1qHRotZ1Vg?=
 =?us-ascii?Q?vakVzkTZqbt3PDebAHB3Z5ocZ5Atd2nJieExTUPA6F7cLszqPMu/csSo06de?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hoJDbNXNwi4eqfQ61o8VWTspJyQoBo0COJn3G8U04nIW9e4Due3zaPTGkxNwCfpOlwbryw5wT0rtdKkGe2eIlkqXGxLud0LST3FVS0AQVfUbrca0nJZpwU6rk2O3vZ6m7viyaOT8Bksb4HaEhtYBZZ6YyM0yUipFZqRs5JXBZJNDV0DhRYCh17L2Tq0L/9WaL7TpGQSRs5ESb5YI1tEhWNMZ1rwqOZ19bU77ApDzV/SqP+VHh1F5aL8R4zXOg5qMOF47i4zwFT4HpyYiPyI0r1LOT+IuakrYfogHQP0T+QRIHTv70x/7KIgI3d8aTodw1c19IYNHYcXsSWXPM1/CFQy+z9TSDsZfEK2mfpxsEuZ+2rKb9DBIGRDhfZ3U0yYlc4w3/mKlDCjxEr6/auMUSt3/JoDebzubB2dLhRNsogzW0DrZGY40459W7jJY7dRO2IuA+ea5H0WkN4TVc49VWe712422O8UIHnpO4JEz30CQ3WapOOy93t3YZQaurWrzUwpbRgFxcDvpj0dHF+9VjnR/dtZCRYUDl6GsARFFH0SdF+7X6bpafh0BmEF8UNS3NcfjujtoxT9XU5d0L/4Q8uXH4ns9wD65p0b23OdAX78=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d8147b-bcea-41c1-2d81-08dcf1267dd6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3366.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2024 16:44:40.4455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CGD0Tkvpi70FGGiehWzpSeRQ9COO1oFxWgaoN5BXWnIpdPZv2Mly3avjKd74lyvPtEdKPPChAE8HzJrXLIpAxwbasU8O56N8LPhSpPfRtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4827
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-20_14,2024-10-17_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410200117
X-Proofpoint-ORIG-GUID: uRFiiLiUKPqoPE2TJnEVGc3bjV7skgiS
X-Proofpoint-GUID: uRFiiLiUKPqoPE2TJnEVGc3bjV7skgiS

+cc Linus, vmalloc reviewers

On Sun, Oct 20, 2024 at 09:00:07AM -0400, Kent Overstreet wrote:
> On Sun, Oct 20, 2024 at 12:45:33PM +0100, Lorenzo Stoakes wrote:
> > On Sat, Oct 19, 2024 at 05:00:37PM -0400, Kent Overstreet wrote:
> > > A user with a 75 TB filesystem reported the following journal replay
> > > error:
> > > https://github.com/koverstreet/bcachefs/issues/769
> > >
> > > In journal replay we have to sort and dedup all the keys from the
> > > journal, which means we need a large contiguous allocation. Given that
> > > the user has 128GB of ram, the 2GB limit on allocation size has become
> > > far too small.
> > >
> > > Cc: Vlastimil Babka <vbabka@suse.cz>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > > ---
> > >  mm/util.c | 6 ------
> > >  1 file changed, 6 deletions(-)
> > >
> > > diff --git a/mm/util.c b/mm/util.c
> > > index 4f1275023eb7..c60df7723096 100644
> > > --- a/mm/util.c
> > > +++ b/mm/util.c
> > > @@ -665,12 +665,6 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
> > >  	if (!gfpflags_allow_blocking(flags))
> > >  		return NULL;
> > >
> > > -	/* Don't even allow crazy sizes */
> > > -	if (unlikely(size > INT_MAX)) {
> > > -		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
> > > -		return NULL;
> > > -	}
> > > -
> >
> > Err, and not replace it with _any_ limit? That seems very unwise.
>
> large allocations will go to either the page allocator or vmalloc, and
> they have their own limits.

Ah actually I misread it here, I see the allocation gets immediately sent
off to __kmalloc_node_noprof() and thus that'll apply its own limits before
doing this check prior to the vmalloc call.

We actually do have a basic check in __vmalloc_node_range_noprof() that
prevents _totally_ insane requests, checking that size >> PAGE_SHIFT <=
totalram_pages(), so we shouldn't get anything too stupid here (I am
thinking especially of ptr + size overflow type situations).

But Linus explicitly introduced this INT_MAX check in commit 7661809d493b
("mm: don't allow oversized kvmalloc() calls"), presumably for a reason, so
have cc'd him here in case he has an objection to this which amounts to a
revert of that patch.

Assuming Linus doesn't object, I don't see how this is really doing
anything different than just invoking __vmalloc_node_range_noprof() direct
which we do in quite a few places anyway?

I guess let's wait and see what he says or if Vlastimil/the vmalloc
reviewers have any thoughts on this.

But looks sane to me otherwise.

>
> although I should have a look at that, and make sure we're not
> triggering the > MAX_ORDER warning in the page allocator unnecessarily w
> hen we could just call vmalloc().

OK I guess tha would be a check prior to invoking __kmalloc_node_noprof()
-> ... -> __alloc_pages_noprof() and WARN_ON_ONCE_GFP(order >
MAX_PAGE_ORDER, gfp) ?

Sounds sensible.
