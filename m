Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D801248892;
	Mon, 17 Mar 2025 15:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742225439; cv=fail; b=nVXAwSbkIUN6EAIVIlqvF2WgGQxtBg9yymjYLz4Am7xitSCkG+vFxMMdjA3FT3k/BHOqey1uX4PTFflq5B465BZmD59Rf8nrzUDnorZ7DiwIOR9cZBwv1CZJnmzD8vN1CbLpwJZnN5JSJMrfJTWOuIY/vuzrgaeGXdWV6ZB0HuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742225439; c=relaxed/simple;
	bh=5MbQ2Bt6oUDnvtDx6biDoIdGW8TNejVputrBqB/xU/I=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=tVQsaEWqBqkVG8ae0M/nnN0aQPINEgqWikVMHzAVwKPnueYmKJFgQIyRi3KgsXwux2T6sfnr9NqeqyylIdEFz/Xer0o5Y4e4g1uyPDetEvl4fr/ZvsQMbzH3l75zf47UpY0rDM+20SU/JhiwFy83tWBr4IMWB1zNr1FsBP0Oh04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Fj52jt1K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Xe2UUb5V; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fj52jt1K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Xe2UUb5V"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HF97t6003149;
	Mon, 17 Mar 2025 15:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Eq2+e8gCKvOERoPgrK
	39e26w3/roLs8w0EDD7WxqjDo=; b=Fj52jt1KipVfaQGy3BhmlVOBr4BTKgrtou
	rbtNdlT4+Se5uYO9EGKieYkzl59Vb1+Az7CkhGAKcglbgxsgc9xF5RbfHTfP9xG/
	rZf8W9truNLiA0CvyurthgvXTrwBMPcPzFYubP3t9r4XRQlLMSPs8qukfWzjAOFc
	xMuA3BIAgAgVW8yMC/hK3LJZVv22N88u36p/ODeX89tKLsLjdrkNwsST7lLgMLZv
	dmIJYFWtvRqh/D/az1f/Lk68XLTiY9eaaMtNMid8kQ9fSN44ppvbYFgzVfOw6D7F
	vpcftevbH/G6b2ZJGwqfoNIBz4PpZO1hEMuPEtEOFhp30phS4UaQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1k9u3mh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 15:30:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HERCIG022470;
	Mon, 17 Mar 2025 15:30:19 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxee2w0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 15:30:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U6AnFOsBRRknXDLSKW9VZFtgbUH3kEvd1cqc7RXRTYhHCsQHfN9TnbXosXFEFl1aZ5xq1+R0csaYb6un7pm+yLvodHbscLwNuuO3nzanTjrA3t5BD+yHCuIAUxmlytqQvXLVTUjczg7YiiSIfBy4D1CveKJ6kJsxuCMeRfv3jiH0+VXrhCCUMI0EWI5/OaLt9RTwLw6QI0jyU5XUKins8dIf9uCDevUZ2mJF9FjbGuKuVfTXyciNc4b4LSvPZ26k5TvamOD0JOecRfKOOJNc+5qiI1KXb/Q9sRIBcuCCKzVyfjRtJjm9TO74Z77QQEeT5SHy0EfDfnff6LcH/a+TUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eq2+e8gCKvOERoPgrK39e26w3/roLs8w0EDD7WxqjDo=;
 b=T30A9/aHOwtFyNRZv6wGNfI3Il1bM3Ll3WZDIokgAV2NBDR5FsBNxAlRmhNyKZIYjGq666AV7QVuEoBL9K5rIUmKl6WHT4xExD6oAsuG4viIP0FR0NhMizr4tNe0SgPtZiJeB2fMBvJRSaYScjmihHoVpT+sUyv55mGQRHsgFPNb4XlHV8DnqssuQzH8HHBg4DEEfhbj9GA1s34hvq7u98ne0Az3P2uXvg0HSoYIp8timMyT1+x3ly7IM15voMoVpe2qQtisv8sLAGj2oAgwOhMIl6Bv/2wF4mjlwwgpCLGhrPaPApNf2cuq58LSpMASrsCGeC1MGtTsLCYqyTUdTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eq2+e8gCKvOERoPgrK39e26w3/roLs8w0EDD7WxqjDo=;
 b=Xe2UUb5VNurChAhrScFTYbLApfOg6vJCF1VkxobPQ55DLDviOthxC7C0dnSKW2kkdTi1P2pfDI4IzDS2QUp3LFd9351R22RV9BbfZhqTtXVOvStEoQQXpYVzh6qLNDLs8p/nv/FGwKLpGIA96ASTExuIwYB3PdWX9FAYhFLdbbk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW6PR10MB7686.namprd10.prod.outlook.com (2603:10b6:303:24a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 15:30:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 15:30:15 +0000
To: Keith Busch <kbusch@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
        Christoph Hellwig
 <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
        Linus
 Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com> (Keith Busch's
	message of "Mon, 17 Mar 2025 08:13:59 -0600")
Organization: Oracle Corporation
Message-ID: <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
References: <9db17620-4b93-4c01-b7f8-ecab83b12d0f@kernel.dk>
	<abk74sbsvsuijqhohyenl2mecz6unmkhavkga55fxsld6m6ise@ncbz3xmjlymw>
	<510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
	<5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
	<0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
	<ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
	<ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
	<fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
	<Z9e6dFm_qtW29sVe@infradead.org>
	<fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
	<Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
Date: Mon, 17 Mar 2025 11:30:13 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0949.namprd03.prod.outlook.com
 (2603:10b6:408:108::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW6PR10MB7686:EE_
X-MS-Office365-Filtering-Correlation-Id: 8770b2e5-9c44-4d9c-e2bd-08dd65689d6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N2NitkgKMBXgiq+xuSzfO8udvGGXvGd8cHp8cFDQxaD+q5upMR2HZcgRTxgK?=
 =?us-ascii?Q?ec2smpeYIQiJOI+uS37LSd95lZ2MzBbH5kbvGacNm5kU1NCnJlTZWKI8r5t+?=
 =?us-ascii?Q?kY7/G6qOczdUx7I1DbxC6v15erfaJt5D/8O6VKCM4lCzOl3j/nVA8xspMIlv?=
 =?us-ascii?Q?C07N7jotVHjfnBAM1Nkx5FEiO9cz6IeAaorMaSqlv4bldFlEqgfHMGJffSj9?=
 =?us-ascii?Q?4oSJkTWmZYKcD8X+zB/NJB7yxaUCnucWL2WpSE7cyldTNhWhctZXFjJOqC7B?=
 =?us-ascii?Q?mQsN51hmXP1AHOORWTGIjUebi62twhg8xhsc+OKTJ5X+pieKa0vo8BQ9DKnZ?=
 =?us-ascii?Q?LccYVzPeMgceqdKpoJvLDLLu2JbWuhkrkpZtKgz2d3xn0fyyfirqILha6d5g?=
 =?us-ascii?Q?CcAh5RRjvqa4jer4oOgc8h31JHlh4KL/KTk+PbwUWFJWJqhdLYdvN2V8lC/I?=
 =?us-ascii?Q?Iq8eDDNpUzO3u0+JMQLRg41p8HvZ5qJXJr0Uk1fD8Yr0P9zl0QsIPptNl2kQ?=
 =?us-ascii?Q?7puHhM3UaQKHSTxsLx6BXJFmIUSJfqwjrhlkSlhBnjeOagUehp5TihHoLSab?=
 =?us-ascii?Q?L+RLqCu/vPDsXY5+9kfOEFplQnOEMWDQ7lJvP+g4DR0iu6nB6kxAUph1rZGJ?=
 =?us-ascii?Q?OLsfYX9F0KHuf3IiS5pFGU4xuhN8frkjijlcIl7s40rM0Kw1naSq6nby9cUY?=
 =?us-ascii?Q?IjZl6MRK/0JraAMT/vQ0PhsfALIlUByn4hbJohTS1nyd1BGAUYKg8/+70+Ba?=
 =?us-ascii?Q?47XH9CaQx3w7Sz5gyZShG0HpFp+H0FGZXio2okvIhnvPjV5Snvwcp5U4ss/w?=
 =?us-ascii?Q?iaTNCcL+2GfhOTGqhDVA8HxoEmLkFZZi/afChxzf5QmQrSZzoqtIG4nsE/PI?=
 =?us-ascii?Q?YbjiDCQcsAdHQkFJ/WIuCOCwmCkMirAR0f0rN0A+hyiGcH5QFyvIdrw9Eozc?=
 =?us-ascii?Q?SB8WtIWFQzalOUH9BgUPyeNvMpcJ6ZfNYesrzhVeR7NQGzEnDPKRiWP/Agl9?=
 =?us-ascii?Q?HU3F2a2NIs2MmHAn72+pU3mxbzkyteJA2VX7j2bnMHRpBrmHgHbAJje/Rdbd?=
 =?us-ascii?Q?cgy6qQBcBDGKC5zhdR185F2N0lhuK0WAFiCB7sW3QHEUOcRhiQ7dm7UXSKNx?=
 =?us-ascii?Q?JbIAJ828VDigik7twsvAFaLMXMIjRHwlFj10id+qBzq+MDik5Do5ytOnzoZK?=
 =?us-ascii?Q?U/7yBLlXejylJ8u+eQ6lZVBfxKPbv7DBE2vZNaX9IuGtunQljMhnsOnP3jux?=
 =?us-ascii?Q?rHPSxXQh4gP7J/ikSGPjVkIOpTg0X2osQuf212ziC3XSTx7E/I6/CuTPWyTC?=
 =?us-ascii?Q?XBPOMkr4ILHb1nGpIC/CtZCWW8uZ8t4NMp9H//WgXSkzaLEYgQQDraw3t+ln?=
 =?us-ascii?Q?Z/W23EecOp1SQvE/DDWxxLew9FIz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5UgBxHA0d8oPzyTTyNuwaoG2SZBkUG73d0ewo/5/JOg3RAtW9WqogWfnBWzw?=
 =?us-ascii?Q?Zl1L4Pt0st4W+/PgvyfdXK61e/bCdGgd9LzaGdcQIeGLwz8EyGwdIT4EQ0gu?=
 =?us-ascii?Q?WvOEYpI0ND67qqC4ta1OCpgMdNQQs5U446KUrxZ1y8nTki+RD9hjwMa8LOqt?=
 =?us-ascii?Q?JVCSvCD4t43yFJYtNsmKE4wQiLJueYRorM437o1rWsuP3lxh2rL6TG7YTMtU?=
 =?us-ascii?Q?VrKw9UAZaQaGCJe9g+Hqe3bC+9rdzhbdIZ1gfF8DyhE/j9CHEdAY45N5t3gG?=
 =?us-ascii?Q?ohxjw8W2XVawyXdFWPqkQ3Q920hC7mPHLXUfYwKY/GhUGV6kkM+ASVUfmV4D?=
 =?us-ascii?Q?oqb1Lu3XU22miKLrFCBDdI522hypCy2NzLoWTiHzLXubxwo2OOPkABEaTgQl?=
 =?us-ascii?Q?k6YzjVonoj3MeVBDrCQtwLb8rabL5w4jpsKbulYyDzwx51o/3SAxb8XSno2W?=
 =?us-ascii?Q?DXB41oRhB1Gcmc2lrCT+AU8TlmYlaFdcl8VKBpCY1rjANwPJ5VeDuTpNZhV6?=
 =?us-ascii?Q?cQgH5mY9+qgnHVgDEAfiBhVHiHtyL0XbY31idIjWTHqEoZl7uJG6Um6A6cjS?=
 =?us-ascii?Q?XFoY6E7Cxm8GbabaF8DlO4nbsJSe8dhs0EEYRBcqmqvL9EHPe1md8M6NLEeg?=
 =?us-ascii?Q?WPHXbiBMqJuL2BMCy4aQ3KNetI94MXypRnL5/FOUv6zkKNEapiBra5JWEbkv?=
 =?us-ascii?Q?H2OQ5ruks4QDqt3JfACO0lC7y8on59vIHLtRTO/uKZjX7K0J802y7ssDdB1n?=
 =?us-ascii?Q?YE/lSfegiyjOtBb5/+o9fITZho3f5FgS1FsNQ1i1cuQwnBvJmHHbJ4qQLP9q?=
 =?us-ascii?Q?070brAK9wHe3pM75bGeAQPwd3Vmsh/cm4+6aup8NGdOE2YvmXJFHS/kgZnIl?=
 =?us-ascii?Q?AWBTwCIqOpnuFrNR2gdMryWZUeiUJUubOxX64FPQhUERKOGKB5A+FtpYLVbd?=
 =?us-ascii?Q?4un20MxnmVEh2SsD9gKT1u7tFXXWpc7MdXbhcLxNGev+372TWF9PPwCBsSHp?=
 =?us-ascii?Q?0qDfEWWgrd2GSe1d1Yt2NjZnPL7nSK4VwxkgHQj5ZdOtLfDwq/zMrTHFUEmF?=
 =?us-ascii?Q?yQAoyD8aETqQGLiKGm9f4xeuicqSWUQ/hhr3kaO8g4al/486wiuzY/KQdh0S?=
 =?us-ascii?Q?KMYid1v4XCGgZVd9wNmATqZphRQ5XNmd5vsvXtd1FO4fS62q1AIZkzoMGu1y?=
 =?us-ascii?Q?cQ2huNQ1NVCuCUrxKMPwFFL4Tqvi6q8z+B9zh20kk4L+PwduDvu+8uVg9I7M?=
 =?us-ascii?Q?oslBBsrgYxtBu6dtSSmOy6hv9iO8hU/YrNuMqasxksTwzgHVK+vwxHJH0xmT?=
 =?us-ascii?Q?YdcdB98QiM9VriBurywUX5mORDum+4iWzQUr+fpxEO9TFB2qVl4EHyJ9YwVo?=
 =?us-ascii?Q?9IfCWJ5hO9MuSdpyPCsmc06oaUnDaNJlqOGKcINemJySjtXdCn6cGLrxkgW3?=
 =?us-ascii?Q?JgREAs7a1kSaFezPiZSymjF31oVAsUYfofh7QUJ7MHj7DO+YGk16aNBBFvWJ?=
 =?us-ascii?Q?1vHwDI5pOUDRhHP+ZNd89Wt4eJTp180umcqtOyZvaOcZ9RVXeqnwQ+kUG0N+?=
 =?us-ascii?Q?JsGar82ZnkM36hqCDdPvDQZkZDhPxcVptBskzRiCaqyVN06uazHxu8Al78cB?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rYDfUKeuZrYx0O79OT3n1dhiPVz3z3CGY/BlXtYE6vsJYhocl4bC6ZwMd48cP/MMLJQjdLH4HkNmj10Z+lxiRh99x+Qaf7tnyHu7lVRXDNkiOmXzQ/tpZTqELRFeWzPLaTVNLzb90lqpL5aEbkK6cCu/PzhYkea0kMgSzG7xnT0i+8bKAvJC0e4c5LFC+tK8C7feO9IH0OoSDw3sJ3N1p3RJE9UrsrQdg5TXelmPRQ1VIah/QCNAUNcitPG68tU4cMr4LoqQXtlrhgyZI59RQDJ/iFxKpDB9jbp6j0QnVrUymKAEj4Lr0zrTQDyxVOEW3mJNywZtdKHzZfNnS1pP8Z5bgx3KTWmZCp021A3ECLKwo41c54NnHj6LErYi95Squg1bKQJyu8+Vm3kqj8YDHdCY+k2h0DbQQKVGQCITI+tx7Zu3gqwMTeqf5wanFxPDIMMXpxIRSyYqkCB2O0K+bnkYjM9Hvgj42PA23mSGIFD2U8uMXKZ8jum2R1vTsSkkxy71HA6hGLWaoLGjMX9Q2F35gir0igPxLxN88ATupzrlinxLXMreoTzwYUtWmY/KE/Zf57ABF+M1a3CxqXkIM8FGk+m3yo6MdkWVjw14J/E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8770b2e5-9c44-4d9c-e2bd-08dd65689d6d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 15:30:15.0522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AXIIcn2UMGz6g4re8iv+aopl4oX/ZlDDzSy7Zui4JXKhNgRhnOhMof1kpZvIraX991I7tL3c9K4B/YaMIdaFhZqVlJNQpxt5gbaIJPDhkkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7686
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-17_06,2025-03-17_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=663 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503170111
X-Proofpoint-GUID: ZPW6MbxpBEHh8KAjUjYy7-3b1U2frKHW
X-Proofpoint-ORIG-GUID: ZPW6MbxpBEHh8KAjUjYy7-3b1U2frKHW


Keith,

> In my experience, a Read FUA is used to ensure what you're reading has
> been persistently committed.

Exactly, that is the intended semantic.

Kent is trying to address a scenario in which data in the cache is
imperfect and the data on media is reliable. SCSI did not consider such
a scenario because the entire access model would be fundamentally broken
if cache contents couldn't be trusted.

FUA was defined to handle the exact opposite scenario: Data in cache is
reliable by definition and the media inherently unreliable.
Consequently, what all the standards describe is a flush-then-read
semantic, not an invalidate-cache-then-read ditto. The purpose of FUA is
to validate endurance of future reads.

SCSI has a different per-command flag for cache management. However, it
is only a hint and therefore does not offer the guarantee Kent is
looking for.

At least for SCSI, given how FUA is usually implemented, I consider it
quite unlikely that two read operations back to back would somehow cause
different data to be transferred. Regardless of which flags you use.

Also, and obviously this is also highly implementation-dependent, but I
don't think one should underestimate the amount of checking done along
the entire data path inside the device, including DRAM to the transport
interface ASIC. Data is usually validated by the ASIC on the way out and
from there on all modern transports have some form of checking. Having
corrupted data placed in host memory without an associated error
condition is not a common scenario. Bit flips in host memory are much
more common.

-- 
Martin K. Petersen	Oracle Linux Engineering
