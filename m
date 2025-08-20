Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D9823AB9C
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Aug 2025 07:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755674611; cv=fail; b=lfK7heM241DGNxM6RQIy4bIDO94d4Z5jQFOBQCclka9fMn4yuIYEGA0oZIh6ca+BRLn4y8zHDRiWWrwHgIsDcInogOgnKkzONKgGd2zSL7U6AgeYr7+iFqvzrE4QRXd+bwrqsRL5uIv6YQtLeRawJbIsNtK4QGiQMoA1LThSjn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755674611; c=relaxed/simple;
	bh=2XJwAzsMXuBO0bHJOwzxmo667bOVqvRH+Eta2oMoi/4=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=EHQhp/AHRseZiTBkAyLwoCIjTcHG0Npd0z03e4DvtMo3knbB73gvE+3ed4pI08G06mbLhFs0KGpPmcN/R6Yad4sa0+xvQUG7ue355zgO69aF6aaRQPuzUC2lrFoBJ+uuArmURpYbOvN5qMyQlVIyUl4WHtxw7D7MnOI6Lrz/lJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GQr6sPuP; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GQr6sPuP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755674609; x=1787210609;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=2XJwAzsMXuBO0bHJOwzxmo667bOVqvRH+Eta2oMoi/4=;
  b=GQr6sPuP2AInQ9ua7/a4qfP8WbRfxm1UcbsLIg0uixCZ++cFMqccLzcE
   /0KXGoGgq1vCc4tRvGMAOcmmfcwnZ62cUpMirZiZYLTDDnDKfpQIBV0Ib
   /vnpvG/i6Vrfslzo1bx19nkJe55yA861JYWVrpks14nssMV4bZTTSsovv
   EGhWuCZn1nx+kJa2E6ZO4sv360eRMqpfHZl+s5D2R4hbozE+YvvhSb42A
   8P0ioSYQt+mAPFdjw2Dleru/Yx++/EjI/iMpEHaUr4Oz3eDXZqLFPrKme
   ar3nTU465T/SG6PGlP/DDRWn2tKhXZINIKGo3dsSCNBrMr8mAzrQ1Uncx
   w==;
X-CSE-ConnectionGUID: aYAviEbITBqbuie/BaYOKw==
X-CSE-MsgGUID: TIlAsfFLSbqhiHzYqzD+oQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="58031784"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="58031784"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 00:23:29 -0700
X-CSE-ConnectionGUID: tymavqv7ReOm4JURs8lksg==
X-CSE-MsgGUID: r7cnIrrbQweteBEtKm9TYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="173308704"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 00:23:28 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 00:23:28 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 20 Aug 2025 00:23:28 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.75) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 00:23:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g1Cz22MlP+i5Z2NQm53BozOToS66IrquI/5yZH1NZFdOfl/StVh7nn0u1KXzwVfqBRxiJ16gRr0kN4uzpGGtMyZI5mWkxPUGT5kpL8dR6ypm3DgVM/WhX5pDtiFWHygFUW33rhY2Bke1WNPdzaiZ0lPqZe+tLSAUFHaKW3Ugn0IL9tnnCJN8xHewwvtQpdwjIg0OSujpU1MZqFqP2TyralR3rexuLnIFkl22EkBHgi9EcDXfUaHqKkGS4a1MKuq0cLKRmpXS4VTDIBf0+tjoH+vIs4pohl2862WihJ3TCKndRuLrj5UrA8wTsGzKvAQ9hfa1MX0H6iwtJAtwRvYKzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hPhQEc+1tdEC+68gAGAMsyDujokjuEtG1CRA+FffBe8=;
 b=OAf+GJTPZgiY2Nm2yoDOQj2EheNSE8NQ0npAZlvh/qwqQFh0qd5aSdOuglgpmNe/eNRn2lnoY7DEL1QaSmdq2ZQeE+KQ2kS/BdTv8Y9SOUZS6g/MK1bteythF4dSPIoe/vPPWNZj/JeewPAnmaq8HUIzj0TbT/stLE2J2FO/aEMknVXADMJbJERmD+rk2+D9qOlRHHhuVN6QZ4UDyHj0cbUOrKjZG5JRyPqtaMRiTNvAKSAlN86K/45xBDZugMo6n2rcuhEACf71lTcHqrrcFAb84PJDjH1yXzHERrSNB+C9T/JSTsDPwWbz2OQEyuxXOzfXwr9TjfnsB1tVYrXfTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by IA1PR11MB7917.namprd11.prod.outlook.com (2603:10b6:208:3fe::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 07:23:20 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9052.013; Wed, 20 Aug 2025
 07:23:20 +0000
Date: Wed, 20 Aug 2025 15:23:12 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
	<linux-bcachefs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [bcachefs]  aee94970fb:
 xfstests.generic.173/174.fail
Message-ID: <202508200820.7f866400-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:3:17::19) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|IA1PR11MB7917:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c3beff7-18a0-4121-0bc6-08dddfba709a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FdCnnWgqLeLV1N1KHNGcLJGFoS5HHXhtA+1X9gJE9H2is8yGfOG3chrFGo9C?=
 =?us-ascii?Q?fYmBSDbTgEub/GHmrJqoFPw0wstLfpSay4dQ7L7PXq5QtvQPhnd0IQ0cycQv?=
 =?us-ascii?Q?XyaHT/5DUx0N9LmZqRrDVsnbtERUnurGZsjZnVfpckGl/BImCBdulBThRcMu?=
 =?us-ascii?Q?XIBk4YEm9mqJY+SVY4+rvtr0IuIlcC5c7ePxku7298M79qHtv827Ri+deSE1?=
 =?us-ascii?Q?Sv3Fo6OexHz0zju+zParENI9Z/KaqOqGubabJ0al36goeLX+gQ/2ksDtmcTG?=
 =?us-ascii?Q?H6eMr8IN31GLC9cRZjmviSMi2Kr7r++afVuP/X37MgKDmemePRSkFSO9O31u?=
 =?us-ascii?Q?mW3R/WzsR9oIFHBBAh7VmmbWUlaG+ZZUGse62OrQxDqHJKmjfbp2Lr173f8V?=
 =?us-ascii?Q?4Sf/EBA4c7oPz+3teSIZS3vmQhBBxZOdGkEqB2BQxuWl6Ntvj0s7FNtuxAIK?=
 =?us-ascii?Q?sydV8QwBLZr6sFKGxC/vgzH7X0u+JNPLKkYdZjqZG2K7fQ5kB6jJDUUmhbsG?=
 =?us-ascii?Q?HeJLQqYi42Ca1pSEDH6oLjZnDrgxvM5CuVGh8G9f98h4VKBonsIleS6APNlB?=
 =?us-ascii?Q?bFolbwBQWAl58Vd6WdokaAd6eH+F5B6XZMsaJZydN1oWfFx5Ak65eu3KHjAr?=
 =?us-ascii?Q?VWYBmbGb2qTPlFYqRmlg7nbmuZ6dABJEryXAGu3/wox2NKZVnBoJsit1BSPi?=
 =?us-ascii?Q?YrX6iDkC7GsWKI3y0lLrn2MBSdy0tnpo7UK5Ahgu0My3biKXZloOpw2X7xcv?=
 =?us-ascii?Q?UqQueCpqWns+yGiPCCU0Kg+5yg1WJedfB0ZruhMjMPb5bClN1Lw0Oa9bXKct?=
 =?us-ascii?Q?gBXN2SFUSwzeA7L+8DNVzbbe3rN+4HDtnYcPgP0o6ATh243tT0oJhnLYjlQH?=
 =?us-ascii?Q?qtDnncjG6YIVfjc7v2i6yhW2uPBIPD0RMt/Wt8E30Q1wbTXnCu0aCDJKn4Sm?=
 =?us-ascii?Q?/ClZoDwZpxQxxwX2qdq/vrTHNaRA7+FylJLpL80LxtbA0cmGggQGQIiAdvlq?=
 =?us-ascii?Q?X/gTkZtZpxstwZVmyRcxfT9IG/eJb+tqovN4ggA75uJ/uyyQzxlZQuBdqPEz?=
 =?us-ascii?Q?0xVv/IQTQCgwkUgE3iPhCBXErw1/xHz6O+daX3YAv6y8zC2ZcfSBPAd2Kxjm?=
 =?us-ascii?Q?2VZJCv3TFsduSK3QvLroSAOEBPe1q3mtuPbaCxbPS6mxxMxCCKm7B/+xtdLH?=
 =?us-ascii?Q?lTl9nF4kJFKznpnMtj9hQNa/pVOSUwTVSZzR2a8F159VA7dGhKuJNTmhqXUz?=
 =?us-ascii?Q?qg4zNlVJQPh32uGiKhAhyezDk08wRnR8jQOwi+p+ymTN6BjdnezGBClx7LWy?=
 =?us-ascii?Q?HIGCn3jDKEOvPsRBtxb3DNhuyyU58m3UylRVnzGhzX34ehA7WPhYtbWzSNmS?=
 =?us-ascii?Q?1SGUyhj0WmOhVvy5cufXT9Mvaw/g?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ACTOVuPit2OJwB2qB1ULvTkrTuWr41AZlc16bDY4xVkdJBF/kSn5vWyhSNGg?=
 =?us-ascii?Q?W1xo4tYw+3X8cMlZ6nzI/4sFew9SdvrujR8o+pdIsESaenSPxb7rHAZoz0y+?=
 =?us-ascii?Q?e9y3vecg4bBc0gsBGAytFeDwgsEG4RUZtc5IKY0199lx/EDgdMpcR4vl6TBo?=
 =?us-ascii?Q?OS+BUwPOk3ETglfGIvBlINy+dXTSjF1vjO63OhFjytWCT4QEXroN+i4TggN0?=
 =?us-ascii?Q?yzDlUIImH2lQyO4i4nDgN1BVeWEWFq6IhLijb5mY3wXeBPsmZJI6JyAktmyy?=
 =?us-ascii?Q?E3vVoKd3H7TSJDGwJ2DDEIeBeYAPAWDrJ3A+IHFpBsR6lxH7ic7o1K6EvUYl?=
 =?us-ascii?Q?7RVJQUPd62jJdiIbbq/Ga/vdeSFyei3kLMjcCk2hWyn7lLc90Y+jlyL8mdWa?=
 =?us-ascii?Q?YTP3HxVBEOShXnhHodgyNBKKMlGvpvVLf0gl3aNHqNzQENTqkyuxhrwtpMMf?=
 =?us-ascii?Q?Ll4mcJAkfGGb0gemrUVGZJFtBBPC2w71vxLgLkJQT+hfRjgGdxEuMTrX8MLj?=
 =?us-ascii?Q?t5klaenZchd8c3nGWFy8DAuTKdmV/q0Gp9pVeq/RSGiBdO0CJAF1hxEMKTdK?=
 =?us-ascii?Q?zyUaISqUU3fnSila9JBUmf4bUk5TAZE2GfD5/8wrO9nvq1pMPETT97hxCi0E?=
 =?us-ascii?Q?MKAOjw15oDvCwG5dtSofhg8n+NgcjjVMeJqS1YkhkQj8gJZ1iPxUf8LJP9/R?=
 =?us-ascii?Q?K1b0c7hkRf9PTVFo90gwMcK/BBMYym9ESoAygG+nxc2xr30nK6E0oDTLUst9?=
 =?us-ascii?Q?SxEhaB6l59Qibqh2ZdKCDGfvsnSuc0iauECdMrFlhmBfdLs08VUakd68+tq3?=
 =?us-ascii?Q?MdtThFYlhZJVja0WPrbDJEeSi8vGKykNyImwo9Ab6FY5GnomP9+gRSVg3Udf?=
 =?us-ascii?Q?ebDgn7ugeGTYKE21gCgWW1tUilvmAYcnkSMYCVCJj2Z5m8mberLz2+0j+aWC?=
 =?us-ascii?Q?RWizklhaKlSRYeFutrpKna1H9d4g5crgN9xehFVLgACjZdkqXtWQ381Thp+e?=
 =?us-ascii?Q?Xnykbe1GvqKVpOg8W7wFP9RjHbh11XKle6tSEGRJbc1M+DTPKvu9Q8XlaYhZ?=
 =?us-ascii?Q?9L+n25fazntdqCIyKJ1Yc0FPnR253lE+gQECiQVZqg7Nw27xs3tTKUgbOf77?=
 =?us-ascii?Q?NxWFPc+Tu5ZDGLuLgPx1ZrJwItBZyXCOInpkYo1hycNkw7DmYWRO/pfuobb5?=
 =?us-ascii?Q?0m5/twx7XyZKAfiggUXXtb9NfOzXFhq+fmYuulDm8kbK4bhIq9r/RXcuKlM3?=
 =?us-ascii?Q?H87LjoCsB82PoE+ASSH5PCIyUUNkICaBmsnWWsbxmANPYsAtcsf8CeEp869t?=
 =?us-ascii?Q?gck5Nwn/2YQiKjukpa2usMlPNC0P8a1dSi++IB4kMTd8Z23lejJKjizGIIlJ?=
 =?us-ascii?Q?7YfmoZRMPyZT2Pq4+7/q8Rp2MxVTfsLtHg9ck7ZgHoys05rrVxL+vXhpNLkk?=
 =?us-ascii?Q?Q52Txo0AG0REedz9ieCGvGf/XEiGF4A4QIOESszbGtu0lkGnL+1zr76e6RX3?=
 =?us-ascii?Q?DNGosK8PaDlksrrVOJjQkj3vtJXAGqhKilM/L7uuPHIdvCvClA57Gy5LB/Ix?=
 =?us-ascii?Q?NIou/9gF8Mp1gx/K68dHT2J8J4MdHiG1fs0XCFbUWWHCmkJiMsKTe0j7EZEo?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3beff7-18a0-4121-0bc6-08dddfba709a
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 07:23:20.3291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tgbEyJ1xr7UDNjZahtUfPdtm/P2OdkP44P6njPM5utbHfLVlQWqpQf5MZKRv1T268J2MgF+ys17WzkWKands9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7917
X-OriginatorOrg: intel.com


Hello,

kernel test robot noticed "xfstests.generic.173/174.fail" on:

commit: aee94970fb69ca330ecd0d4eb8a5e5d63f6ee649 ("bcachefs: Increase BCH_MIN_NR_NBUCKETS")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 3ac864c2d9bb8608ee236e89bf561811613abfce]

in testcase: xfstests
version: xfstests-x86_64-e1e4a0ea-1_20250714
with following parameters:

	disk: 4HDD
	fs: bcachefs
	test: generic-scratch-reflink-08



config: x86_64-rhel-9.4-func
compiler: gcc-12
test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202508200820.7f866400-lkp@intel.com


generic/173       [failed, exit status 1]- output mismatch (see /lkp/benchmarks/xfstests/results//generic/173.out.bad)
    --- tests/generic/173.out	2025-07-14 17:48:52.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//generic/173.out.bad	2025-08-18 10:06:20.148006154 +0000
    @@ -1,7 +1,3 @@
     QA output created by 173
     Format and mount
     Reformat with appropriate size
    -Create a big file and reflink it
    -Allocate the rest of the space
    -mmap CoW the big file
    -Remount and try CoW again
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/173.out /lkp/benchmarks/xfstests/results//generic/173.out.bad'  to see the entire diff)
generic/174       [failed, exit status 1]- output mismatch (see /lkp/benchmarks/xfstests/results//generic/174.out.bad)
    --- tests/generic/174.out	2025-07-14 17:48:52.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//generic/174.out.bad	2025-08-18 10:06:25.277802711 +0000
    @@ -1,9 +1,3 @@
     QA output created by 174
     Format and mount
     Reformat with appropriate size
    -Create a big file and reflink it
    -Allocate the rest of the space
    -CoW the big file
    -pwrite: No space left on device
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/174.out /lkp/benchmarks/xfstests/results//generic/174.out.bad'  to see the entire diff)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250820/202508200820.7f866400-lkp@intel.com


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

