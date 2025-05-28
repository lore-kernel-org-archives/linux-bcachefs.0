Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3952C242D64;
	Wed, 28 May 2025 06:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748413922; cv=fail; b=IkdE6sh2Qnsat4HrLbbqnr70RL0qCTur0r5h25IiBrkoK+HBt21zkm7QyMOlvQdAt81FZygqg+kBNR5rHgIivflh/L4QXXQiBk0iVJi4rcoSkT+AiEs2MpIGkpZmVxX++IhsbU4WRhduwI5s1vEXO1YG8Bg7ed/7TnDaVVYOIqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748413922; c=relaxed/simple;
	bh=PcHxN/0ZF5ClTDhF+aQkxIVaFTGNXu3KgBPD+voUUZs=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=BfZU2MU//jEzLs2Yy6CXdrR3JGcZPlqVAuhIF7ksKcTf6yrGKr5b0lFolXVibzzzsCi5s9sqPD/9cZMac8Ywzq59NcDP1/3UTkMCMo+eHkbqyEHxhr5c8QRqByEo/xwpEBrJIoKn7H38fdJ5jY6xUFw4lVp2oPuqg1+9F5B2iu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DETqzGBt; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DETqzGBt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748413921; x=1779949921;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=PcHxN/0ZF5ClTDhF+aQkxIVaFTGNXu3KgBPD+voUUZs=;
  b=DETqzGBtturqOmbI4XxqNSbavxxnz4UORW51DviDLO0/Est67GhHfiw6
   42cPdXlwemwLmaHt+FQfGkxacXpFDHIDdPaMPksRNVtVu4hGDnmK+4+Dj
   7ZtMfBOQ8VGX7+qPPlifU5LC80Tf7QR4192N7n6uF5zkH1tWoEjm3nYBd
   fdsMVfoELql4g7EpKbneNla7jf4PqyHpxoeJByQBTl45+KChHSUo6Qels
   dbWzcqvU56v0cv+XIkcocHux7qt1JpgIczMNLTK+Q2/7uK9XA6tR8Xc1O
   AbFmAvz1kC2mTqrJejuDOoZkiZPWlRNgLP73hxlI1xxm2Dwa8MJ6nblov
   w==;
X-CSE-ConnectionGUID: sGI/AYcNTlm/wG3deNQ9KQ==
X-CSE-MsgGUID: ybv/JNFISSi6WDCrKYMKFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="61775555"
X-IronPort-AV: E=Sophos;i="6.15,320,1739865600"; 
   d="scan'208";a="61775555"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 23:32:00 -0700
X-CSE-ConnectionGUID: UPARn8UGQfKmTslrB3+wbg==
X-CSE-MsgGUID: 68RpKi8dTza3HHPF5L8GyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,320,1739865600"; 
   d="scan'208";a="148435436"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 23:32:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 23:32:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 23:32:00 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.62)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 23:31:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aSEhCC/4EYEa3Vd+NlQObBcw007ga8qOL0zwmuiENkodrNj+zq0vuOXhLSRcxDxDjFX0CZhASw2FaHNzE0QpHJnGP25OPShfdJfPLvpnRj2hAckoEJ/tdmiPGdRgvavW3KLlzoN0a6/txELVQfQgr9YK0kQd098wTlxsDMb5wOOgB/0suU9Im42ujRKpDmNlFiNCbhLOnftvmDLSqxmePqduMQkBK8Byy1AG9BJYJE1mDS17XdEXpZzcwMpctkPrdxAadhm1fsdhcBIGiLrHSJhmIpOQmqaJMUES9f1HO16pB4/lCa8a+XvrthBj510SdsQYY4Z/yhYw4UDJJL4QCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tGsTLG/tCEb7qqVDQvz3RRtycMfgDurEn8VywQpx+K0=;
 b=kZISdIOcAgxGZyRGV77NhHbExIEPaL5D65YyWBcPqgiciLThgt01WnH2a1X+JSkO5n7g8DMsDVhw2iaPp3c7fsPg4+ox3nWtkZcYLNBfL5KU6BPgQK2wKHpXcqWe3iWwDt4RrXQ51gMb/pqcDPa8zsYZruuMemlkcm4bTQXB81361YlGOQoglpxnkS2yzPpVOgnLgBWR/9/gUrB8J0zmzziM7CgfSMcIB40ybnWLhup2dMZnML3Mow6YQlm+3p4W6rdo7ZD3EX4t67O6zv9r2S01TCMZgLXASX/jDTp61cjSaTHVSNOs7fkul+Nlj8cUnOFVwFFtNtkrmRa/zGudRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DM4PR11MB6261.namprd11.prod.outlook.com (2603:10b6:8:a8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Wed, 28 May
 2025 06:31:43 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.8746.030; Wed, 28 May 2025
 06:31:43 +0000
Date: Wed, 28 May 2025 14:31:37 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	<linux-bcachefs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linus:master] [bcachefs]  cd3cdb1ef7: last_state.incomplete
Message-ID: <202505281410.cca50993-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: BN9PR03CA0806.namprd03.prod.outlook.com
 (2603:10b6:408:13f::31) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DM4PR11MB6261:EE_
X-MS-Office365-Filtering-Correlation-Id: d2528165-b537-46d8-394c-08dd9db14fcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VLjFStrB4LgR6uV/iL3vo2k1fhqFKXKX3yi0LLBOmYzQi/WLjOij5zvaJ1oR?=
 =?us-ascii?Q?3an0K0SebIKxfvSrbElDl68QTzG2qadxopgWBx+iAJHCByprc0X97DW+VzR5?=
 =?us-ascii?Q?n7apfCk8EeWtJ5ftpLO+GzXpl7xiyqwR/PsRIdIntsEgY8Wla+ZNC7P4tO4y?=
 =?us-ascii?Q?HLSWB5ctIQ7bSELIx92t8ha5R9V1e0+YNJY/DI5rBnrzIrZQPJcBCYyN4wqv?=
 =?us-ascii?Q?51LkDMuMZ9WtX33hiU0GkF3r8fR7DNLSD86JUolkzqhmuqQmzq4PzadnuKCs?=
 =?us-ascii?Q?6BlPLgyfXEfLFyTbi7rZ/IJTMFZiRDGWkMnjSNUL0wEZpcbebkb9vntcKPzY?=
 =?us-ascii?Q?94nwVLOUBouKxMwYzGPehHL8dqDIy09P4jpZBTKCPbZf8/rJocjF20vg73pv?=
 =?us-ascii?Q?QdSDRu5tisc8BgSiPUK8idzYRhcD/UGA/q7IomHyCJ7tVd7Lo4tTUBNUFymE?=
 =?us-ascii?Q?hEfPEbK6RTmphV/KsFHDEotj+DtrmjUOON6ab8CYkewgX68g/fXhm4l6jJEk?=
 =?us-ascii?Q?y+q1xmVxnzJw5IA3JtWZfcuofkR2Qxnksv1cHz6I1s6Zu5Gtl5d9GYlXUXY+?=
 =?us-ascii?Q?cxZV1WIE8Nae9jXn8ygQftTqit0nU5T1iLguXKOupKg+vjNF7SZ5lPurz6MQ?=
 =?us-ascii?Q?fJsiIdxSFVwNG8IHnaSeXrh8p20+6rHbIFvA1n+foF/OTJXrjeWZXfGSNr+a?=
 =?us-ascii?Q?9DGlhMVDaf2DuB3KhfrI3/D5em6D1aCnMxaydtX0HJL5Vs5Ppr0BZ8SmD5xB?=
 =?us-ascii?Q?1N6bTTfkyyo0YSgxRkhCTgANN6meuKYuKukv3PXPpAY4Q9kEOWmazz09aSqG?=
 =?us-ascii?Q?ooD85y/0W4CumMw8vfDnjsZglYTzGMrZF+KrOrRWwJc17C2FiqLfHmCNnycJ?=
 =?us-ascii?Q?xfT4ChPtwKhFXMSRMAdH+KsBe6yQUh6sYK9CYManXJ2FeRgMdEHIMwexrhVS?=
 =?us-ascii?Q?S62oRZs5bK6KLolGy9gWmGWY20nYayVCxLjkG+eM9vbYBhkr8kcG2xY+9mX3?=
 =?us-ascii?Q?7wBKKgKQ3d5LCyrbmzZxU5p3AMgq0a+42x+N/Swn6uSg8X1LjNVlzEhGrDMU?=
 =?us-ascii?Q?0drcXWIUCSJUB1jjStRxKLiR0cpoRoFSG/vCcvi1cOlkrFIhVCMOOm2RJuov?=
 =?us-ascii?Q?r/CAy1HTYQv/4TNBdbz/2KCtlxeTFrUXlB4NYsqpKMAXIlaSz0clr5CXQaj1?=
 =?us-ascii?Q?qtLK6ou/85rPuYrNo3vsiDitxA9dIiAadp7jGdls4ihjIgBCmfAHY9HglRek?=
 =?us-ascii?Q?RCMTQ79PVdN7ZwzNcej1gLr6vNQF2Gsz5fTeKN6+EcP+tztr0+mA5jGU10ja?=
 =?us-ascii?Q?PhIYE+QdI/ZSviUa9bUL5cOxT08/8bcm7bhA8MVnMa5pz+eOrTMcfXGuItaP?=
 =?us-ascii?Q?zED08j/AdkyvgW5gh8tRWo/Tj7T0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ewGanIqzLij1ZwK2upS6dyoMWdvt7SL5esshKE8sqHVoHzIfAPRqL57GHjKB?=
 =?us-ascii?Q?mdmlqI6mrlcDeKluOUJbJHVY5Kogymn1aWQ6KM6UEJ1CnY7SI92LScFdeyBC?=
 =?us-ascii?Q?S323fY19Svpy6+4Up/YSnZO78Msdr+srjR6FUwMtofqchYozt9vrJpD31NPo?=
 =?us-ascii?Q?UtwwBvfHi7rAK0hJNjjAnKXukgOZ38ESzk9P+g/DgDLMzm0Y8FN+GEeEwJpy?=
 =?us-ascii?Q?zt1pBSVJj+3yZpSrhIK+cJwSCmSivAM4wyFeIzRsqd7aWXoov7QlBjHpxcxS?=
 =?us-ascii?Q?an31J2GFbdh7pOVqP4jiutDeqEIVOUMg7FVY3ux1biCBohaBYBuNe96uV6FV?=
 =?us-ascii?Q?5w0HPSM0QUDo8/08rz/M9OX8C9cb2hrqxbU9ZYfIijRGs9EQggid70BIhorF?=
 =?us-ascii?Q?LIeytpTxKLBrJqYbdRl2DRxhghemWnFcW7W6Pr7bRPXVKphpo6obWsMI7RQH?=
 =?us-ascii?Q?ksHIf04NOVMeSBaBrQsPLc8e0tTccoPljeDjafdpIjD/bWOOGNlkbFiFvsKr?=
 =?us-ascii?Q?GfgWKKo1DiCqFtczL/R0VvQ5horCGpVeg8IzfxWi4YGWsPRJmrsjfcOs+/Ou?=
 =?us-ascii?Q?01cvSceUPCUwQi2OtKbtQa1pY0wMgtdBiu1uT4yfzr3376aS1rrwhIdK7E66?=
 =?us-ascii?Q?YxD8g/AMCaBMPrTKhGATlolH7PSjiCic5EnIWiz2uzURdYFvXhbQ4Gs74HXT?=
 =?us-ascii?Q?iZ05jNZtgaa4aS8QWG8GqgzE7Ktv1YbE2lHC9LqT/QsPzmhf97/iXqP4BU5l?=
 =?us-ascii?Q?4Eny6MY919pcfNScNBIkZcRkEyK7jvOWFq5xyMYGAPTVTWfnDCm6ZayHRCbr?=
 =?us-ascii?Q?RPJRXzQysQ9CIuWSfZIZlajQY0rExrIu3JIYyrZ8TMp5BrcT0QIWMDu3YzKp?=
 =?us-ascii?Q?KO2C1q+nlvfZ0/A/jCUtJlchhjyXmKQkHP6erX4bEax+bMcyF9KW7FuqfQjH?=
 =?us-ascii?Q?OzrlPyAZEK8vdU0YUndi0PR/Iv7QzG8WaQDpCpT3JCPUZ4ifhs7Uqk3Go7sn?=
 =?us-ascii?Q?04Af071UrFDVpUFfWtLAF/rmkyuOt7D5emO3SV5iiTchjFfbuMw9a5kEdeDi?=
 =?us-ascii?Q?3nc6uWDyyrPjz+2vfpO00K28kT95VCtQAWAYY5AAGfmUHMmtUyhkkGMGBZyT?=
 =?us-ascii?Q?DcMEfErVAM1PdqSY+sAAVOZAc45HdQ/QbRqyuB7yOZed3jeMCUjQELPGLC2X?=
 =?us-ascii?Q?oUTm51K2q5BfIGMGC/3mIJa3q19VXFqzRaOKW0xPiNBnfP5MYrM1VOLYmVzV?=
 =?us-ascii?Q?B05EoLFBM6ezyxWoxNWdge4aqMGPrLk7/uRqcj1zBMeVvaUyWg0egkKsp22/?=
 =?us-ascii?Q?G5HxDMBoiC7nI4xIyGFMV62SOdnJkj9GPk9O2CMV5du3G5cnOUzrz3sAC6Yr?=
 =?us-ascii?Q?9khxUT2HYUNPGQDFaBljNezuWuC9SAPgOeJ8Q16BdDaiuWpsYLOljkYURFXI?=
 =?us-ascii?Q?Rv75pRzdcggay210Sy7GvZ8vOEXFfQ48GplxESu4zF8NSKeHWq6gM4jhzcnb?=
 =?us-ascii?Q?hwJg67U52M4CJeueV6T9g0t0Jm90DiRElRhCtuVxLMHOJJZme+0QsHtuuCbl?=
 =?us-ascii?Q?D1kOXmSsqCULVXacNi8NudTf81LbFpPKSXywOsGH34DzitmA9KJYnNpIwivw?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d2528165-b537-46d8-394c-08dd9db14fcb
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 06:31:43.3384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8uvfYabCWYGybf1LEXmcPweD6ZRNnhQkqaywxrjCouAIzjKCX4mnSVUUHGtiKJlnScwL82fOqykjd72EL3Wg4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6261
X-OriginatorOrg: intel.com



Hello,


for this change, we reported
"[koverstreet-bcachefs:bcachefs-put-folio-assert] [bcachefs] 0718bafa21: last_state.incomplete"
in
https://lore.kernel.org/all/202505081551.92a07edd-lkp@intel.com/ [1]
upon Ice Lake.

now we notice the commit is in mainline, and we captured similar issue on
another platform.

below full report FYI.


kernel test robot noticed "last_state.incomplete" on:

commit: cd3cdb1ef706a1ac725194d81858d58375739b25 ("bcachefs: Single err message for btree node reads")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linus/master      914873bc7df913db988284876c16257e6ab772c6]
[test failed on linux-next/master fefff2755f2aa4125dce2a1edfe7e545c7c621f2]

in testcase: xfstests
version: xfstests-x86_64-e161fc34-1_20250526
with following parameters:

	disk: 4HDD
	fs: bcachefs
	test: generic-group-67



config: x86_64-rhel-9.4-func
compiler: gcc-12
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz (Kaby Lake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202505281410.cca50993-lkp@intel.com


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250528/202505281410.cca50993-lkp@intel.com


similar as report [1], from the dmesg in above link, we still didn't see any
Call Trace, but below informations


[   41.372233][ T1447] bcachefs (sda1): starting version 1.13: inode_has_child_snapshots
[   41.372233][ T1447]   allowing incompatible features above 0.0: (unknown version)
[   41.387511][ T1447] bcachefs (sda1): recovering from clean shutdown, journal seq 20
[   41.395125][ T1447] bcachefs (sda1): Doing compatible version upgrade from 1.13: inode_has_child_snapshots to 1.25: extent_flags
[   41.395125][ T1447]   running recovery passes: check_allocations,check_extents_to_backpointers
[   41.418989][  T335] LKP: stdout: 307: Kernel tests: Boot OK!
[   41.418998][  T335] 
[   41.494922][ T1447] bcachefs (sda1): error reading btree root btree=accounting level=0: btree_node_read_error, fixing
[   41.505517][ T1447] bcachefs (sda1): bch2_fs_recovery(): error btree_node_read_error
[   41.513201][ T1447] bcachefs (sda1): bch2_fs_start(): error starting filesystem btree_node_read_error
[   41.874130][ T1447] bcachefs: bch2_fs_get_tree() error: btree_node_read_error
[   46.990004][  T335] LKP: stdout: 307: HOSTNAME lkp-kbl-d01, MAC 48:4d:7e:be:54:6f, kernel 6.15.0-rc4-00141-gcd3cdb1ef706 1
[   46.990016][  T335] 
[   47.103180][  T337] mount: /fs/sda1: can't read superblock on /dev/sda1.
[   47.103189][  T337] 
[   49.036739][  T337]        dmesg(1) may have more information after failed mount system call.
[   49.036751][  T337] 

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

