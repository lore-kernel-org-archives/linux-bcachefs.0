Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEB62222B5;
	Mon,  7 Apr 2025 04:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744001188; cv=fail; b=NlgDATNtw//6prRutyrPyunJ5KDV++mkmLwOzm//ukjIoVSFJW2hfsX9sp+wn2j7AC7Ke9ep/Qx0Eye+aKoyL9I4PUIFDB4dJTxYwvwREOS8joZtJpPOmussPFBtv0Dbi3cVim4rv8moD6AjOXg5w6UBfOlB61LOfShyVLh/wEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744001188; c=relaxed/simple;
	bh=uX28Ng+JXptOqQfIGzbLvHuGotKd1FsEdqwI9fbhEb0=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=oEAhXTYXQmVom/XQeujaarOblsUIOuT9l8MaXwVfiW/oFBqxwthq8L09CCv3b6T7UrdEH68i/Jo7jOIqCImr24jvpj1Z+UqvWi1PzyK/JnqYM9jhaHbSOMnv1vek1l00H05qliEccFiv5f2PV9jzPF29JzwibdBiIVofxOZekcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Onwx40BV; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Onwx40BV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744001187; x=1775537187;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=uX28Ng+JXptOqQfIGzbLvHuGotKd1FsEdqwI9fbhEb0=;
  b=Onwx40BVzZteiRU1r5JmbcIautxl+BfGAZQ4n7cpEjlSYp9gFDFglVwZ
   a0GUdoMcRPx1XD/9q9Tbk2n+8aVjoS5MX+K2iB6GnC6F5a9JgjY3hBx+P
   B1KAbNxSmh/PrPxZTiAYbrHX/l3dC59lm0/045idRodF9duZmYkKdFA40
   qUM6W4qWSqoblkeVtRHcymka2Dz6CxEI9jaZ2FGj/cG4/6Eh4YI2Z1ftU
   kQVAUoibx5lT7MqAv2bmVMGywReSeV2f1Sp7BM2OtGBuFIM/nRX2Oz2h8
   o6VXdQ6NNuP3WlcW5SUTq21g0cA9fNDpox7dsPnVjWmok8hTEwGjsxeWP
   Q==;
X-CSE-ConnectionGUID: Gqy2sW+6Qf2v1BSkMfQc4g==
X-CSE-MsgGUID: j0OAMBjiQ2q7NjkL5SOBnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="45385812"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="45385812"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2025 21:46:22 -0700
X-CSE-ConnectionGUID: dz3AO4z9TMu/wKge/c72GA==
X-CSE-MsgGUID: //GsKKUQRx6phRUQnT9asQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="132680507"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Apr 2025 21:46:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 6 Apr 2025 21:46:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 6 Apr 2025 21:46:20 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 6 Apr 2025 21:46:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a1D5g5l5Oy1ELRiuDSEGsyNHQe25UNlXHEtyYlGYawE+Zp43fn3zmNtsmXyh+7DCTA0gRGyTSJbSYdFM7Y65wWTiL2waJ6bYf0mVxNQ4831atlSt2Y54fQE3wiRvgnK+u2oPeaB9C/fd4i7VR5B1dziEa6xkdz1h5MUX/dDqJoCGw6xTqvFDb5peN5u4uYxz0Fmv1VMam43d8oMVDtsJt8oZQxmJJ0Auv/UBxSrwVsSVKsCQ52bu73mMCrXWqj7l5UVJIU7b43GUsp7iFv9HQGKBgl/4n3URF7j5xT7lDZTk7/BTbf5hV8ksV56VLalrEr3ro7InksmU0K9SOhle6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bq3whpS14BWMoSjWtsM9ThWca0673Y7Da52PxsjmnH8=;
 b=bme23slCLK47QrzRgjtpFhGvvtpHc+selne4KAM53ufz1yEetGhHlb9kXItGwyul+509ZPgU42OfDSyINk679yaw1JFQtLjiaCW4GAVBoXpdc5b4Hw53tK6TTZahF4Vk92D+d0UvOGv6hgyBa6EWXo061c77UyDtSasBOe8pNSLhEgV3KP8xj3b8X+BMHl/FsGTKclgP/gslbDkq8jGDhMken24u/Sbru+8xBqVOMRfwCA6+dUXPJsu1rpN9BFI6ohallTEKLteDRLx/ah/bMCGe8yar5yqINIlVJ8LeQivTzXAQg2je17mXn9NFKtku1rFOh6Sh1z4tIlroy3YlDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS4PPF900531A26.namprd11.prod.outlook.com (2603:10b6:f:fc02::3b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Mon, 7 Apr
 2025 04:45:36 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%4]) with mapi id 15.20.8606.028; Mon, 7 Apr 2025
 04:45:36 +0000
Date: Mon, 7 Apr 2025 12:45:26 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	<linux-bcachefs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linus:master] [bcachefs]  2adfa46734:
 BUG:sleeping_function_called_from_invalid_context_at_include/linux/sched/mm.h
Message-ID: <202504071013.cd2f0072-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR02CA0091.apcprd02.prod.outlook.com
 (2603:1096:4:90::31) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS4PPF900531A26:EE_
X-MS-Office365-Filtering-Correlation-Id: 901fb349-91ea-47fd-3cd5-08dd758f0991
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?T9R9zIuALcqlkSqkmqxxiOZUZjTWwxEKJkGBS6T1iLbc2YYRbXcJfCtg6HhG?=
 =?us-ascii?Q?lJDfAvjTy3TaInDedzb98/5zG1Ms9X+PX9FIwAmmO2aZdne3QMXBQYqlTlJy?=
 =?us-ascii?Q?Irqa8sPVYkO9XvI6enxYxV1UJvaxirczfoRDWuvZcVWCEzg2GESyGZas0JON?=
 =?us-ascii?Q?imXhFdHqAfk+J+Pa95Juf4sLSpwnPvO4PXZjHUR/MuLdMSwJ3ZK5oeCKkibN?=
 =?us-ascii?Q?Xz7w3ZXKvU2mNVGT+PZVBO194cWkoDoJzSV+XZzNV/3LDdJTygCUWcMOVH1e?=
 =?us-ascii?Q?nYpyXjbO9VUbzHbClfkCplonmh/niVw+7GT0W6or0FkF6tGWG8+uAlu4zd1l?=
 =?us-ascii?Q?GksdBBwKIct34Cvg9+qx4nJRT6/fRnzLSzxv6pYB1JYSQnWdecqFTkCV7+74?=
 =?us-ascii?Q?vYnR+fJsxe7xVNSceKBNMO8Y/LgdzIJufTNUJGR/bqx8fx7BOA47kTJiqkYT?=
 =?us-ascii?Q?eFna8Qe+3rcjC5RZOyhSWtgq2eN6AyWcWHDYgnSwLOarRv5aojbh0dSQgAtC?=
 =?us-ascii?Q?gAFUHiXVTt4Kdy8slU1q9S2/O8oyTvUeaGvN2EBwqelLi1l8wH/pJtbDK0P4?=
 =?us-ascii?Q?byL2Ott79O+fHXFJuE9dCpckgHL55Y7yQ39RKXXeI4h32AcXKPgMhZ4FM9xb?=
 =?us-ascii?Q?aD2vspH1XZ+CMHHJ0xzbOrXtnGIY/BXqkZjO2OzAr0+pQ9qnJbcMNTKSRLSK?=
 =?us-ascii?Q?FGruQJYfVLW4UcbqiiG5Nd3TBENd1dL0vH0wNUu9174f2lnrYPmH4icayTvS?=
 =?us-ascii?Q?KjxA3xZXb/f9N2e9neHCKdllNL+IlJKmJX4+d85E0dx6nrJa200ey51SUKro?=
 =?us-ascii?Q?opaj38hTnRLz3Df/3LIlL7D+dkS4Xz+QEt9ZQQGd3dmtkTPtUgjw+b7KDaAD?=
 =?us-ascii?Q?5b37+DU0LeQBy91IhU0QMaOWJc/blKq/u5M3UQrCQMmL+BmTw8x2diwjB9+F?=
 =?us-ascii?Q?2OknsV35YnVNhE3bjM4CTTeb6N99kuaZnrH1krx0P8dfgGKGMwGkJA62GYCF?=
 =?us-ascii?Q?i7qa1m5Kwai4zCv0I/Xgk3xEQXb6LH66fGpOs4mwVFir+jT0+Nt78aZBExxJ?=
 =?us-ascii?Q?wQewgPPEy2zABH33nojGx5DZYaYSdQkz/qDdEf58AVN7HlR3FyxfxjuEXGgL?=
 =?us-ascii?Q?S5uPbp9Kwkfsi4xEz6uFbokSmVe0hoG3lw2SquGleAfbib71yXu5+BIfse6o?=
 =?us-ascii?Q?0ExKcWl1k2UA57mhkxW7uW2Y0gOzeSDu4AECPPcpw5Q+jBoz3WenhHXsgZ/t?=
 =?us-ascii?Q?Ji3DbtxgkdQllawlQc+pGyqeeP1EyfHXQbQtrUBIT/qTYXaAzcoRWFh4rgI4?=
 =?us-ascii?Q?SxAqTlhSmi3lKzHaJ1MfpDc3XZRWG8dN5VuLq4d+Mqx5Jg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XWhUqPuWJ6kryDEXbkPk1xdOdh+LOGVRnBh8mH+POL3C0Utv8B0kV0sL3/HT?=
 =?us-ascii?Q?Ek9zhIkmVlrOHDrlXfIvnuKd1gNHQp/1rappmRRwN78MLCabWvReTWkNq6iE?=
 =?us-ascii?Q?EugNDVJBfx2RP94QTqNlo3AVwS9Nl0GzueS2hoC/GioIfeoWv4cWKGVkbdfD?=
 =?us-ascii?Q?LKkxRvvT6qYXd+c17vO1YANHudvoUmL/CVT1eV23jHCNAaHakyCLctv8pPco?=
 =?us-ascii?Q?CytJrV/XJc4hmhwNptJlNnfxPQkHVckmfar4jAXudB0Uh1AOSWhMlXuHpOaF?=
 =?us-ascii?Q?/kEuZ0022igCq8tUaes+32ARneb9DhJcgaNoze5aFcNi1XRNRYwM93mYma2e?=
 =?us-ascii?Q?jAjGsTPjfTJ20bJ9EAiQ+lQBFRxTyB/YnsH2hZXF/bKlEcQqBzF4f9UroKYD?=
 =?us-ascii?Q?Sxplv1pxNoO7saHY9yGrdVjvGmkOGHVm1RRuVBpaX7feiC0bimtxLKCcyV+r?=
 =?us-ascii?Q?+G66Bt2WGJTOYMhZiROYhxFheGFJhiG1osdqzpVIaeXUTic4StCsZnB53Y3J?=
 =?us-ascii?Q?9g7BoQTkccJY2uDe0R6g/SKX+ObKRa8KQYV2hzQ/jUUzRoRDrT47GMw7WsuL?=
 =?us-ascii?Q?muYMk7APe4c6FwmfoJmkyYD/bsfTJQ7oyqkXvXN3fhA98zjmXgQEP04KZIoe?=
 =?us-ascii?Q?6eOpbdNYG1BJXrYfUXo97DvutY3OV8aibrqWnGYWBggjCHJd2jMpz5kGRczG?=
 =?us-ascii?Q?JorqwnqD86W0NUh/IPSdR6UZoRANIQVK9uF4zIuno+ibhov1IsGMAzWHnLfT?=
 =?us-ascii?Q?24W4cT3Cd7K33TRPourko1lAZdJFJXC+WgE4ZUjCoM4ffzZxDCpddT/jKMPw?=
 =?us-ascii?Q?9COLXlXx2564yPvTWPvl8q+6dPqmcwW1FwBa3BMdAV8v8dRswCwF+CyBOrqD?=
 =?us-ascii?Q?jt5dvwsmFX3SY3GxSO8HbDi39RNmK/W68hLiX2yx7i+3bdYanriK8V6iDlXU?=
 =?us-ascii?Q?J9D3d1yS8rh5aLgsrkKJ3vB04T8eoKQ7IdvpeTrkT8/okxiCYsWl8aRC7EcY?=
 =?us-ascii?Q?9U/dZqGTTcD5846inaaQxK2BvDwond/WXlY9docOLMlvCsHT9C5GOY14MYsf?=
 =?us-ascii?Q?8+iaIJWeptjgNE/yU8aE1r4iBE+ePWAey1A8LR3ylPF6I7ttIn/tN3ER1wUD?=
 =?us-ascii?Q?SNu7ZDWW5317ezPAvfOVoDt56voEEcU5GlY08RYTpr8kjQT3zbDF6Fp0dWn7?=
 =?us-ascii?Q?CkgNZt6p/UI+K7gbPHi5PaoIQaH/30wTwYL2vZ+XAdeitenZC5etO1EVZyaH?=
 =?us-ascii?Q?6Y/3KK6RYgQvl1nU/pRXRxjmerNAxCQL1UViVrFBnl7N5aFUFhvurzstDg1l?=
 =?us-ascii?Q?s1+JCzbmh043236YNeIJw7Z0iF0g5oP2LrXDuf5aXv+5l1YBT1UgTTBlogbm?=
 =?us-ascii?Q?oKnS+NB+Iw7ral3WVjuyNuqhIoh3I4rLHPzWkI0cPj1kEn7piM+wLvrOA5xG?=
 =?us-ascii?Q?EfEluyhEqYBcjYXwaoymGgaN6gY+aKdqftigSu2liCR6wzbTvBQAVUp4ffe6?=
 =?us-ascii?Q?SuevJ4Pc93QIxnjkvVtYCkCbke9Jt+iaRgvpLh7i2sgYoIFhavbF3woUIdZp?=
 =?us-ascii?Q?fCnvbKe6muy0ZVw6LphnIV1dnoWsst2qtxwcs57zXnemfZKRU9YKHX9XHA/b?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 901fb349-91ea-47fd-3cd5-08dd758f0991
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 04:45:36.1266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: naoyku8/Ia3BNPhnPu9BkNtt8YRMiEhdXqUKyQO9pCsmMNvrzAUr7WbMlAE/6n7Op0unv6Um4tEmHZVTx5m3yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF900531A26
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "BUG:sleeping_function_called_from_invalid_context_at_include/linux/sched/mm.h" on:

commit: 2adfa467347f6e5d8091ecbc45a78cac3d2a2b91 ("bcachefs: btree node write errors now print btree node")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linus/master      acc4d5ff0b61eb1715c498b6536c38c1feb7f3c1]
[test failed on linux-next/master fefb886b1344e222b3218f3c0165b0fd770e8b88]

in testcase: xfstests
version: xfstests-x86_64-8467552f-1_20241215
with following parameters:

	disk: 4HDD
	fs: bcachefs
	test: generic-347



config: x86_64-rhel-9.4-func
compiler: gcc-12
test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202504071013.cd2f0072-lkp@intel.com


[  168.038599][   T12] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:321
[  168.047979][   T12] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 12, name: kworker/u16:0
[  168.057027][   T12] preempt_count: 0, expected: 0
[  168.061780][   T12] RCU nest depth: 1, expected: 0
[  168.066620][   T12] CPU: 3 UID: 0 PID: 12 Comm: kworker/u16:0 Tainted: G          I        6.14.0-rc6-00187-g2adfa467347f #1
[  168.066626][   T12] Tainted: [I]=FIRMWARE_WORKAROUND
[  168.066627][   T12] Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIOS 1.1.1 10/07/2015
[  168.066646][   T12] Workqueue: dm-thin do_no_space_timeout [dm_thin_pool]
[  168.066660][   T12] Call Trace:
[  168.066662][   T12]  <TASK>
[ 168.066665][ T12] dump_stack_lvl (lib/dump_stack.c:123 (discriminator 1)) 
[ 168.066671][ T12] __might_resched (kernel/sched/core.c:8768) 
[ 168.066677][ T12] ? error_retry_list_with_code (include/linux/bio.h:578 drivers/md/dm-thin.c:599 drivers/md/dm-thin.c:616 drivers/md/dm-thin.c:656) dm_thin_pool 
[ 168.066686][ T12] ? process_one_work (kernel/workqueue.c:3238) 
[ 168.066691][ T12] __kmalloc_node_track_caller_noprof (include/linux/kernel.h:73 include/linux/sched/mm.h:321 include/linux/sched/mm.h:316 mm/slub.c:4066 mm/slub.c:4144 mm/slub.c:4293 mm/slub.c:4313) 
[ 168.066710][ T12] ? vsnprintf (lib/vsprintf.c:2786) 
[ 168.066715][ T12] ? bch2_printbuf_make_room (fs/bcachefs/printbuf.c:61 (discriminator 11)) bcachefs 
[ 168.066936][ T12] ? krealloc_noprof (mm/slub.c:4820 mm/slub.c:4873) 
[ 168.066940][ T12] krealloc_noprof (mm/slub.c:4820 mm/slub.c:4873) 
[ 168.066943][ T12] ? time_stats_update_one (fs/bcachefs/time_stats.c:95) bcachefs 
[ 168.067078][ T12] bch2_printbuf_make_room (fs/bcachefs/printbuf.c:61 (discriminator 11)) bcachefs 
[ 168.067202][ T12] bch2_prt_printf (fs/bcachefs/printbuf.c:185 (discriminator 1)) bcachefs 
[ 168.067325][ T12] ? __bch2_time_stats_update (fs/bcachefs/time_stats.c:130) bcachefs 
[ 168.067456][ T12] ? __pfx_bch2_prt_printf (fs/bcachefs/printbuf.c:177) bcachefs 
[ 168.067577][ T12] ? __pfx_bch2_latency_acct (fs/bcachefs/io_write.c:72) bcachefs 
[ 168.067695][ T12] ? rcu_segcblist_enqueue (arch/x86/include/asm/atomic64_64.h:25 include/linux/atomic/atomic-arch-fallback.h:2672 include/linux/atomic/atomic-long.h:121 include/linux/atomic/atomic-instrumented.h:3261 kernel/rcu/rcu_segcblist.c:214 kernel/rcu/rcu_segcblist.c:231 kernel/rcu/rcu_segcblist.c:332) 
[ 168.067700][ T12] ? queue_work_on (arch/x86/include/asm/bitops.h:137 include/asm-generic/bitops/instrumented-atomic.h:72 kernel/workqueue.c:2390) 
[ 168.067704][ T12] btree_node_write_endio (fs/bcachefs/btree_io.c:2148) bcachefs 
[ 168.067805][ T12] ? __pfx_btree_node_write_endio (fs/bcachefs/btree_io.c:2132) bcachefs 
[ 168.067939][ T12] ? kmem_cache_free (mm/slub.c:2318 mm/slub.c:4609 mm/slub.c:4711) 
[ 168.067943][ T12] ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:107 include/linux/atomic/atomic-arch-fallback.h:2170 include/linux/atomic/atomic-instrumented.h:1302 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:111 kernel/locking/spinlock.c:162) 
[ 168.067948][ T12] ? __dm_io_complete (drivers/md/dm.c:967) dm_mod 
[ 168.067972][ T12] ? __dm_io_complete (drivers/md/dm.c:967) dm_mod 
[ 168.068004][ T12] ? bio_endio (block/bio.c:1543) 
[ 168.068009][ T12] clone_endio (drivers/md/dm.c:1053 drivers/md/dm.c:1049 drivers/md/dm.c:1073 drivers/md/dm.c:1162) dm_mod 
[ 168.068029][ T12] ? __pfx_clone_endio (drivers/md/dm.c:1107) dm_mod 
[ 168.068049][ T12] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:107 include/linux/atomic/atomic-arch-fallback.h:2170 include/linux/atomic/atomic-instrumented.h:1302 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 168.068052][ T12] ? __pfx__raw_spin_lock_irq (kernel/locking/spinlock.c:169) 
[ 168.068054][ T12] ? __pfx_event_callback (drivers/md/dm.c:2397) dm_mod 
[ 168.068075][ T12] error_retry_list_with_code (include/linux/bio.h:578 drivers/md/dm-thin.c:599 drivers/md/dm-thin.c:616 drivers/md/dm-thin.c:656) dm_thin_pool 
[ 168.068085][ T12] process_one_work (kernel/workqueue.c:3238) 
[ 168.068090][ T12] worker_thread (kernel/workqueue.c:3313 kernel/workqueue.c:3400) 
[ 168.068096][ T12] ? __pfx_worker_thread (kernel/workqueue.c:3346) 
[ 168.068099][ T12] kthread (kernel/kthread.c:464) 
[ 168.068102][ T12] ? __pfx_kthread (kernel/kthread.c:413) 
[ 168.068105][ T12] ? __pfx__raw_spin_lock_irq (kernel/locking/spinlock.c:169) 
[ 168.068108][ T12] ? __pfx_kthread (kernel/kthread.c:413) 
[ 168.068111][ T12] ret_from_fork (arch/x86/kernel/process.c:148) 
[ 168.068115][ T12] ? __pfx_kthread (kernel/kthread.c:413) 
[ 168.068117][ T12] ret_from_fork_asm (arch/x86/entry/entry_64.S:257) 
[  168.068124][   T12]  </TASK>
[  168.321126][   T12] bcachefs (dm-3): btree write error: critical space allocation
[  168.321126][   T12]   alloc level 1/0
[  168.321126][   T12]   u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 930249c94ccac572 written 1 min_key POS_MIN durability: 1 ptr: 0:254:0 gen 0
[  168.345920][   T68] bcachefs (dm-3): btree_node_write_work(): fatal error writing btree node: btree_node_write_all_failed
[  168.345920][   T68]   alloc level 1/0
[  168.345920][   T68]   u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 930249c94ccac572 written 1 min_key POS_MIN durability: 1 ptr: 0:254:0 gen 0
[  168.346967][   T12] bcachefs (dm-3): btree write error: critical space allocation
[  168.346967][   T12]   alloc level 0/0
[  168.346967][   T12]   u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c8440b093e7b4819 written 146 min_key 0:1285:1 durability: 1 ptr: 0:255:0 gen 0
[  168.374052][   T68] bcachefs (dm-3): fatal error - emergency read only
[  168.405579][   T83] bcachefs (dm-3): btree_node_write_work(): fatal error writing btree node: btree_node_write_all_failed
[  168.405579][   T83]   alloc level 0/0
[  168.405579][   T83]   u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c8440b093e7b4819 written 146 min_key 0:1285:1 durability: 1 ptr: 0:255:0 gen 0
[  168.406960][   T12] bcachefs (dm-3 inum 4579 offset 524288): data write error: critical space allocation
[  168.443825][   T12] bcachefs (dm-3 inum 4579 offset 786432): data write error: critical space allocation
[  168.459843][  T141] bcachefs (dm-3): unclean shutdown complete, journal seq 532
[  168.856214][ T3526] device-mapper: thin: Data device (dm-1) discard unsupported: Disabling discard passdown.
[  168.867365][ T3526] device-mapper: thin: 253:2: switching pool to write mode
[  168.875526][ T3526] device-mapper: thin: 253:2: growing the data device from 1000 to 1200 blocks
[  171.218727][ T3618] bcachefs (sda1): clean shutdown complete, journal seq 34


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250407/202504071013.cd2f0072-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

