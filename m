Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FE21DED42;
	Mon, 17 Mar 2025 17:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742234299; cv=fail; b=ASAFuWyhp3Cxr9r/LOD1hXEwCLFxwyQCvJ33LHr5Id3e3DewkgAFw+mhvBEJDlQ5/WKzR89DeuMeyo+cgC7m3JwlIH7UecdMG92SnOyfZ0xkR9aVJaBubbpqNAGX02Jr4zLkLs8ZR9cBBKlFn9hQUawLcSTk/KNTxc7LbzbhZes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742234299; c=relaxed/simple;
	bh=AEic1i2cGNCsPD2Q+GxhYqpQwQkpJJsDhcePV9LE+H0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=A7xFzq8/+gmgRXZBo59BC1ExvoTul/e5x3sobtcMRpPboDVkOZKfCiCgnCiWJF3JRc9dvOrrlaEBjKiHSRy/v+2NbSUw7bfrEYAXj8j3WHm/O0UaltUrilfWX1YaNbDmfE5FUj2A8iCGxYT83JrjYhY73uMqCq4p7yaciTABkIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TFPqRZzx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DakzxqUR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TFPqRZzx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DakzxqUR"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HGBnJJ013356;
	Mon, 17 Mar 2025 17:58:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=WRgWIWpCJkwr3VfZqn
	8gVgxNnbLvknnqS1No5WPHeTE=; b=TFPqRZzxXn8ANgGOitFDjNL5xu4a2mscbF
	TCIAU0LyS3UzyYmNszp6xtlvtHYEzt60txQo4XZX+LWhKhMPqgrBl/ZQkin4eLMc
	txCno0bPqwr18t9C2hvoHOU/kFC6iPDSsRZe1EJTJXeIMu0YM4jxzt2KYQoGD01X
	SIS711hIE2BVmVqBH74VMgu6V1LxUEVBzLDnvn7J8G+jtTsCvSPqISZ9iCcMKix4
	Ijzu/GUKtsMdTMcMXqScuvW/AVNzmdcdJhEH8nVV0mRdWvOPC0trJNpYCcQ2OSBt
	1zxukXyfARZpcE9aKaV+YYRWa577xL1Yh/TrTQ5kR159UBqB2Oeg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1hfuk3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 17:58:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HHchwe025371;
	Mon, 17 Mar 2025 17:58:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2045.outbound.protection.outlook.com [104.47.58.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45dxbg98y1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 17:58:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R5igdXJyqH9r20cVKzFb/gcMJ2IaFXcc4oSi9mtKUXVE9CsGiMVowo4UXHrg8UZD6t7iaM1AihrmgaQU6XG1fuKGw81yKvmqjlg2Mi6/o/DBwZ5NzF6H0c1viHbU/wsGIHxmelLMhr8n23B5KzNYJWjKF+T/wSdJwpZ1LsZGnB5MnJbyGPcJMd7H31Zj4Tm9aUhXQGOc7Fzj4v9Asb1Vdg5Zmk8furnsdy/RoTeNUwgGo17HU37RTwy51XoGK8lQfkt2YqyCSSh41pvIeq5tUBmyIOqq6phvjuESkdo+WYOMQZbG7AhH+2Z8UDN+noVaqKXm4MOMtFfoMQl8COPh+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRgWIWpCJkwr3VfZqn8gVgxNnbLvknnqS1No5WPHeTE=;
 b=DbCQULyhHIe47K67qowtyAOHLcQ//60Mrhp5ovzzuEsAgmkoBMXNnJdt5tqajpNmAI/9Z6FfW2oNFYntvS7a1KrzPxZtxdP6vv7VcriHyEX/ukDqGwVGm4DCpWjb481OOENuP24rE7d0mXPYGOzfb++62vCso8sr9uPzpIyp1zEmqzdFW+H/I+QGdjVdyqz5f+2tHvw98pXyazrdDzljqGqj71ajvrGooyO5bCdCF4wzcIZO97qYEq6XYgZYvK976zthHdL4MCUPHBUxOaZk6X4+I+T1dDza4eC1KFdnep9QoP9aR9PAS9332aW6p4wtYtvJqvJ5kE7ten3zzRHSrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRgWIWpCJkwr3VfZqn8gVgxNnbLvknnqS1No5WPHeTE=;
 b=DakzxqUREmfnYHYlbv0XUO2e+m+qgymAs5i4b+EFreLqBUu7Fd22UJCvEUfmW3kCWZca/tDU4vhj3YiiEFC3/qaMxb1JYekS5VcYYPPM39jCVbArCC7uP+M3BIqJsAZGIj3BW3azXdx1btPBC9oV00DYdDO/M0CfNBMtsFzNaoY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DM4PR10MB6790.namprd10.prod.outlook.com (2603:10b6:8:10a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 17:57:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 17:57:56 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Keith Busch
 <kbusch@kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Jens Axboe
 <axboe@kernel.dk>,
        linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
        Linus Torvalds
 <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
	(Kent Overstreet's message of "Mon, 17 Mar 2025 11:43:46 -0400")
Organization: Oracle Corporation
Message-ID: <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
References: <510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
	<5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
	<0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
	<ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
	<ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
	<fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
	<Z9e6dFm_qtW29sVe@infradead.org>
	<fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
	<Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
	<yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
	<qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
Date: Mon, 17 Mar 2025 13:57:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::33) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DM4PR10MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c10ac39-c79d-4121-004f-08dd657d3f44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?swCh3/8naf/Wr+Vw9PJQvNUZbhv19hvOVZtUBrNxEPJB+/VBx2SHM4hZKCcs?=
 =?us-ascii?Q?+mupQ7Ytj0kb9UWd8qS9dlnEfDWzRuQnk+BkY0pzGei9fBynYpBbmOuD0YI6?=
 =?us-ascii?Q?pkfuFTO35PzAMzqkp1JEhLs0WKi9znBntPBEoo6PlQWZXp3Zlli/o7dFhog/?=
 =?us-ascii?Q?qOzJXNDjJhdEthuD2w49hJQvMwUmKDYpRCTMqBxr9Y8LfCUi6ocCoDLb+UOm?=
 =?us-ascii?Q?FE0/5B3ECsYt+OBmoNy90oKfP02Lpi80y5lKoXx9dad6VaF2dt4gWCBv6WJg?=
 =?us-ascii?Q?IFjaH2iturVh+UhK0mfLg+koOCP4YZaEHoe1Ln+1og8ZQ8mmMIvAVf+DyhYv?=
 =?us-ascii?Q?vBQpZLYwsXwIcnI93AdHi7Qc5ntAEnHlDjTNPsCm6+O5FGXRKG9qBUFbz5tL?=
 =?us-ascii?Q?d2Zb3BTy80RMdDPqAIjewnIZDJNPacU9GQYqbvimlOlf7yGY8p161tCLKxw3?=
 =?us-ascii?Q?isNeArSVUzhglqCB20SOFp2z2EhzbXPuq4+E4+k8b9nrl32EjWE5H9nXUCZa?=
 =?us-ascii?Q?87wFOj/MBM9DUcrAlIqbTWrko4jQXIAlgNViy+7E7poopUrB+cXapjhZcVV4?=
 =?us-ascii?Q?Kzb/GJGEzgaN47wSuIbuMEkn/yF1R5s5QEuUedZn2h2awBaR6irK+F7RuSS8?=
 =?us-ascii?Q?VwXOxPDghrAeZ7LsWrIFOYwWLuPE7p5uHEt6lGZ4C/+eVIrY7Ez7rvEuugx1?=
 =?us-ascii?Q?xRnFOscaJRjd0vOHBW872oH6IhJ96qelGDKAk+Ufn/E3US0xZ1wTP7YZwkUc?=
 =?us-ascii?Q?2INr+aFygmpppeKy0WYrMlFEqMcXj1nMlVwDAQhVFc63DYfYEB5lUU3AiQec?=
 =?us-ascii?Q?SLqP1PJRzXl0399HudVcW9JfUeWmC5oAJyKyaCPgqz/mWszF9Hm6T4/eh70P?=
 =?us-ascii?Q?7GC+1hXMxVud5glb1BM4lXa6OAJI565QpnOogM3ps/POROkpPtXxtjLkCbIv?=
 =?us-ascii?Q?7W2Miz5hvfUT4OMdSiSgrHQjwE51aGcC7Eeu3ONVkSayvRwV0htdbG2nf03X?=
 =?us-ascii?Q?7GRMn2+6NwXHmYSihCVFif4+8Iui+tUP9Oc1Te5eTgOkjyGFoTswVUJDqRke?=
 =?us-ascii?Q?8rnI3aDN7IPGbWf0CjrxHSZIBnLeseCcy+WPFsx2FlXINl/v3R+IZgGFvdLk?=
 =?us-ascii?Q?NrM88Xx3sa4cc/9ajMrFnVbNuMa/kXprcq9B2LX9NKtmTFHAxtxX40nsOFTn?=
 =?us-ascii?Q?C3WRsAn+LG7VZYF1jXDs4TI/fg4xNuK9Q7AcN/P+a5NJ6rY+CU2QTvofzFLP?=
 =?us-ascii?Q?IcY9eLhgM/fefRiJOwW9mTupc+q1BP6306q7fBpoYsplZ+y2fLKKQPN2WeYt?=
 =?us-ascii?Q?2XFzJibyfuNjiLqXbtatN5L1v5saHf7RQi+NsjUV3tH8he8T40+UHc7jf0ht?=
 =?us-ascii?Q?3AXsn2RRwJDwJ9KtGiGBt6mI1Q6z?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pFyIkLXFSaMp8vOKjsscSVzLayRwQzmLmeI180iyKK+dv8RUwDBp2XPh1KVo?=
 =?us-ascii?Q?/IZ9TJNPS8sgXxtKEsOm1in5oT7LWFEYy0TnqbNW4BPOoXvT2yzyN6ylfqA6?=
 =?us-ascii?Q?ch+Q9AExibpAQSxgQtC0Yd2fL9OEy5Un3Ma97HxRnmo7b54ms1pJmWQB4SkS?=
 =?us-ascii?Q?R3pG+mtMLWMq6pqjWpXy2odZJhPo+P3jnghQNZII5xNh3Pdj97+pY4kNon+w?=
 =?us-ascii?Q?T9DR+JVWVEINKO6vmT7p4Q/We5t9MTG7E4QsBy6z84HHdsR4D5rVYqSYzTcW?=
 =?us-ascii?Q?ixwyHXDUjNM6LU99qeK6v/oPktl1IPmBRoT1uYZpa/NaeVr2xPIz/ue8BYaJ?=
 =?us-ascii?Q?c/A1Ty2ZppOt8UEwSD//n/n4urJb8054h8hDeAz1JQq7bp6H/+ysDzCOHKlc?=
 =?us-ascii?Q?3vK3C0hWZr1avNhOkJ/l7/2346F4jhb5/RtjVJv1TSwbdQlLd1z3U1uLpaT9?=
 =?us-ascii?Q?qiCn4G6XLgAFvSrM2BIt0G6c7oS7B0YI2RySzs41Q9aStkgMr9ghghnk/2Go?=
 =?us-ascii?Q?XW8462aPNesnNuTrwyjEg8rCKwNgr1BcrjtOMUpoBJLKFIVilvxBDChjqzTa?=
 =?us-ascii?Q?8ny9QgnKg4AzeCX+uhV5aKUrdfzGeBQbUBECD7+Oyom8M+14AyAF7sHX/MA+?=
 =?us-ascii?Q?l713pcCZKu1DAvjdjTTrl069sWVHR2R2xAYgriWRL9qLoDPUa1eGo/KVz8zC?=
 =?us-ascii?Q?/ihV+D8DN4zqOi4efuK43trWCfxeN6tEDa2Tt9hyOtj2HaMbppcKeI9eu3E6?=
 =?us-ascii?Q?TZ4aVag295DxfFrW6//jjxf938voD5UsE4Ia2a/oebpKoSz0r+zwbqEREaVR?=
 =?us-ascii?Q?+HvFEXQQ7zW1XAZ6TLu3CMLcAxg8Z2TD99igFNj1jI+s175Z7dmQLjndg6xJ?=
 =?us-ascii?Q?9Gy66nMLnoPxyCp+OCT26jV+admdFvYQNBDaEtlv94xOXEIq8NBdZ15pC9js?=
 =?us-ascii?Q?orawb99Wl+EnsL/dOsg7grLYojifD34xTJKGPB2T3RLuukytddgcvWDEhTN9?=
 =?us-ascii?Q?msvtO72dmh/Lam2ejIbQs4s1SrcL/AHqWMkmd4zLoo2dyG+z8RcTf/fMBazb?=
 =?us-ascii?Q?pM1qXOqo5I9TrLBoq6q9sOPoLcmhgOTXUeGh5Ps++kugjVUS4M6zyCgW3EHg?=
 =?us-ascii?Q?M6RpcnPx3BTQiSNJx611DeimOWKEONm1chKI04ez14nYd2ImC6p3iT6aejgZ?=
 =?us-ascii?Q?5DY4v3DX3YuMjcVRTLiAAiOXa5O/9gULvExHIVdMrbZfwyP/vVcN7Jvr9mm2?=
 =?us-ascii?Q?t09Ijif2ypJ76aLABCdjviSYo7vWPUt4WqkKk+++xkHnLUOhmhGxqT0U8oqj?=
 =?us-ascii?Q?VMaTyOmoKV08X756gPMBJ9DulDtB57CGLG5/hNvnQyjInnIsKImDKcOmNu0y?=
 =?us-ascii?Q?Bgnxv+IVCOZNRrbg7OdnrH5F5JNIo21X9qeTgH06WDY/yB4cjKJ7WYdqFfYm?=
 =?us-ascii?Q?pgXTPud5mKuvyfj56fpQVmZPJu/qnjiqHsy0/opBYM3WRBBKAwPy5K5RCn1V?=
 =?us-ascii?Q?wmskCzzY6M/JvRU+5R3IvwCaIXJVg3BbMxKEnS6sWivxDeUPyX9/1wVcQu0v?=
 =?us-ascii?Q?a8FE9xxDENB4nKwFdBgnO+Ab1Idl+WizkSrTIH7recCdjbxBTk7wp1O9qziM?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DP45z0JLh/t5xW63+DDIzpswSp/yE6ooH9fkOp8vG4fYXt+mBovZhprOeQVj2CYoeMnjboUQ8CHaiV0A7pJHv581uTRJ9HAI+Md/bFi9mwJGcRxp9WD90LaM9UPp4oUh8/PgpMYzkMwj87LO86z9o9gpWe8N34e6KnlwKPzwx+5LS9yFW0hFyxPi9XR2/h2XG//XlBLSNHxJHvBr74GmUbVilDGZG6qUKvN8GpjHoWmlfeXZFjUNfCuutGFBe4qv716tejkTfMtqyQKY1p+dI3G08UorkSRbShRUcvUZjwyiN+X7FAdsffeQj9fgOWBCUSUlrEO5RyZ48fx9mJTUJxV5uMAAVU4/94OrvNJZePZEf808OUGsxkNoLjdpZNqYLcS1EsB/U2whVy8QSRR8Q+y+SZwNlWzBYor097Furj1aE6OW24d4AqC97qNX48iuiscT2T6VIc0/N9KFt3YW6tjRgykh5YlwtlIuySRFhyj0NsQZ7wDimL41dDBniFIRwq3bGHhxaJKo3k6kcod8STCRje373ttgRj4w/gerdyM6jPyukFj3Q6ldGfLeNEjO4S9iI4FHPmXi9pJRQzY8Z4JEr1T4gED5qjzwQzdUP4g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c10ac39-c79d-4121-004f-08dd657d3f44
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 17:57:56.4580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8xFqPCqRg+wBvmOhh1HyNhKQAD9trYGSDVGQ7GBP7a4pQQ9uAlHePxWVqUl37DjfNK3JGPaCyU45GxpPzh17x/XV9/BR+GbthBQrhOkv8A4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6790
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-17_07,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=640 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503170129
X-Proofpoint-GUID: nqQEFv0dd-DVl_mb0kHSDn5L-KpL0tTj
X-Proofpoint-ORIG-GUID: nqQEFv0dd-DVl_mb0kHSDn5L-KpL0tTj


Kent,

>> At least for SCSI, given how FUA is usually implemented, I consider
>> it quite unlikely that two read operations back to back would somehow
>> cause different data to be transferred. Regardless of which flags you
>> use.
>
> Based on what, exactly?

Based on the fact that many devices will either blindly flush on FUA or
they'll do the equivalent of a media verify operation. In neither case
will you get different data returned. The emphasis for FUA is on media
durability, not caching.

In most implementations the cache isn't an optional memory buffer thingy
that can be sidestepped. It is the only access mechanism that exists
between the media and the host interface. Working memory if you will. So
bypassing the device cache is not really a good way to think about it.

The purpose of FUA is to ensure durability for future reads, it is a
media management flag. As such, any effect FUA may have on the device
cache is incidental.

For SCSI there is a different flag to specify caching behavior. That
flag is orthogonal to FUA and did not get carried over to NVMe.

> We _know_ devices are not perfect, and your claim that "it's quite
> unlikely that two reads back to back would return different data"
> amounts to claiming that there are no bugs in a good chunk of the IO
> path and all that is implemented perfectly.

I'm not saying that devices are perfect or that the standards make
sense. I'm just saying that your desired behavior does not match the
reality of how a large number of these devices are actually implemented.

The specs are largely written by device vendors and therefore
deliberately ambiguous. Many of the explicit cache management bits and
bobs have been removed from SCSI or are defined as hints because device
vendors don't want the OS to interfere with how they manage resources,
including caching. I get what your objective is. I just don't think FUA
offers sufficient guarantees in that department.

Also, given the amount of hardware checking done at the device level, my
experience tells me that you are way more likely to have undetected
corruption problems on the host side than inside the storage device. In
general storage devices implement very extensive checking on both
control and data paths. And they will return an error if there is a
mismatch (as opposed to returning random data).

-- 
Martin K. Petersen	Oracle Linux Engineering
