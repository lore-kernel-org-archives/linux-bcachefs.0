Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984762550B0;
	Mon, 12 May 2025 06:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747031297; cv=fail; b=BfBfFgFKTiYWNJ4b1xynN348xiRECxKrpp6cXft1v1Q6gBe+/r6nRZfDVXKcECm3swplia1ezebW0Zvgb5RhCQFHWyf3iltha1WHm6FYL1SMcogro1vTHT7Ih6WtO993YZpIFP1SeAJQSN4ceRoeCkr082IWovt05aQsp+TO12M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747031297; c=relaxed/simple;
	bh=BW4+z1KlMEWjScwB9VvE0OnmjQUYxLIZ/oP24VI4LyY=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=EEv3DdC0OrBK5RVgQGTm8Z0YSYMrXAtyj1Qp4hbCiXa1WrI1MlB2GyuyXuauHKyuE7gBYBLiL3tqzjZ4I0xpldcLCYwaLZ0qYRzRn9AolTV8gYRUDNKcl272y8YLSj4hd5g9jgO5xl514TVE6Vk1NGdtALr4nHCBTRlz+I0+/pQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VGCMCBT9; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VGCMCBT9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747031294; x=1778567294;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=BW4+z1KlMEWjScwB9VvE0OnmjQUYxLIZ/oP24VI4LyY=;
  b=VGCMCBT9R+BTzXy66xw2OuHH3hRGDiJwY9yrSIJAF4E1m79c8xJ2Pbsd
   AnnEQBVAcCRHlmcj0wmdTjdDjcFaZYds3tcjarRDtVI8EqHY7Ha/Y47e6
   C5dTYuMvvl/L8do2Prpbt4G8g5b1p9sPX9iqCHP8kToCjf90fM+I4K588
   Pp6NCyATYteFI25kaD79HE/GHvvHOWBSklYOhWJbhIc2pPREicY1pOcpd
   1XzU90tzfT4tw1ZNkYymyGkDrZc5gFXjPn01rlowk4I8pDNxeF4xcxbce
   ZeQtmzz8YvS/4H4NL6c8KyZzekOg9DWObMW/izzYdKaT7dpVKEPWCaht7
   g==;
X-CSE-ConnectionGUID: aEWsHH1LSPeU4+K2oq2cAg==
X-CSE-MsgGUID: JID97oFxTdOVkA7uQw+lZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="59476840"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="59476840"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 23:28:13 -0700
X-CSE-ConnectionGUID: +hixzJX2TF6+9rAxSyqKow==
X-CSE-MsgGUID: pRUZpbAPTpuv1OAx0a+xlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="138200063"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 23:28:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 11 May 2025 23:28:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 11 May 2025 23:28:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 11 May 2025 23:28:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yFtYFkHHa+njAzd+b64F12YLD83surGCVPORl+i7aOJV5BHTyeLRzHddEvyxHQb/EWabPpOU8dZTQitDO0xPzeexUSyDhYKTzlDkF8gSift89v38ktXJ1olqPFO+pY9hT1V2qNqisLISoTTAuQ4WhOJHe97+KdzHGXYRrgiZ68DvwPzoDT8JNWuAQJZe3NyTp+uvGtZt6/C1rUlJKsEhe9dbc9gQrDnPI4AHXoEYxYHnf/6TqeajmlxO+6jX7VXbzbuBAZPQqp391eDejNEm6vTyLn1spnnR7X74OMDKvqiSr9P7k/46YxK1YvSJK/OPBy/5rMOexjx1YjUcwRdb9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbk0iiW/HeGxJzKQbHC+2mODB45vgpibAo2yUHT9Z0A=;
 b=OOfgvIkArH2vH/TmI6k54/EHQrBkSpwEa7hf5Sv2SH0zSUqUvPg0RnBP9nZVJI6Cjob2VQyj7oacnI7oZ1YFa74oRdi8eZR1j+fdCVVEaqMwSTzu7xjf2WCOebBFoTJ0Ewd2nbBdOhFyykaciqRt2mw0BEKBFa2s2B0xJI+yBRAcgoYbmGWaEU3K79B3m2eQLhRktGw8djlVBM2UmIp219bmDr9/mQduALYGYtTuTMHNYgGNAhUfp6k1hUGaUkJVKT6W/qvIoxLmlmF0uYw7jmIdwjhlr/TJVvYLYu8gqSUvLQcVVK1QwSBefDGP0VpF+9vYGt2Ro5lxn9uDi9oHig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH7PR11MB7720.namprd11.prod.outlook.com (2603:10b6:510:2b3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Mon, 12 May
 2025 06:28:10 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 06:28:10 +0000
Date: Mon, 12 May 2025 14:28:01 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	<linux-bcachefs@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linus:master] [bcachefs]  d1b0f9aa73: xfstests.generic.094.fail
Message-ID: <202505121327.7f0fe895-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI1PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::19) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH7PR11MB7720:EE_
X-MS-Office365-Filtering-Correlation-Id: 27fb535e-630f-4fb7-b71c-08dd911e2a9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?X5FV2BF1D7Ezdv8+TusPMYGZuAsVXmVRn6zHSTKlQDqCyLrtE/jDZdPBj+cB?=
 =?us-ascii?Q?mH57mAy2nRMpPXS787bjMbUV6v+sdkEh8awdf4KF8dVUxNEXKKY53kRMSu7M?=
 =?us-ascii?Q?5WsW+kgrWTRljfSwahM6l/XagkHTHKJ+AJP8gEa8RAS+dFbyZZIRtp8uhfWM?=
 =?us-ascii?Q?SSJhXL1v2NP91c25xc5b37xdcRst37OxApMEphQAfGAa7CdouhGZKOT8tFul?=
 =?us-ascii?Q?ICQuQGTsU1sdfmMCczSXlTzRcQ8xoZDWNRqRMRYdDLDiiqzmDScZM8q3e1PP?=
 =?us-ascii?Q?+vnL/a2U+5AF1UAwjw4ygFAr7SARx4ZWA0Re0qzpdbTPNRt52ihTHb2AGzHf?=
 =?us-ascii?Q?/nDlt8vqCAwSpQkvPP3wEo6Y6+uKNUdgr2M2PoqQQcn3EnwmJ93kmiPRomvt?=
 =?us-ascii?Q?0HR5UQiFkcsyQwmjzOylt41ROt7vSTJrWn68mLtpy3dMys5rN+q0mWt46ypJ?=
 =?us-ascii?Q?x8JO5sn2X7vZ4pFLWaDLX+AJ+2uXa7tC4axhxP9RJegiW018HYQwiS1fgOIk?=
 =?us-ascii?Q?HlzuXGloBcQ6fCo7Ytw96x4h2AsfF4sX7zHwTsOZwuU/0icACzFnuwgxyW67?=
 =?us-ascii?Q?4qOIZvt2BfIGmVJbtBmMZdYVUzCGeGYN3pkZ0QjcnxIJL5UlQL4AH0VbwiUR?=
 =?us-ascii?Q?nCKIn5c6CAvzoR7L8nTuDaK6HTulEoVnnqWWCpum94uYb+Ad++K9Yp9pf9i+?=
 =?us-ascii?Q?TS4VhzliWIvH+D46YVLFafhldKAFh2plCKh2dHgq9slUQRM2hAaofWK7rHQW?=
 =?us-ascii?Q?X/xgcPdXh2585TSrbJRohX/rlJoLQy1tNMfKOzUvn+/PdYSdaECKuqX4N0O1?=
 =?us-ascii?Q?/o0JrIiLLpWbfY/fuPmGIu5STvOtvxxmE8YRZSC09oHaik230EgT8UIflC2M?=
 =?us-ascii?Q?cM7j3mD73CClg0XdnzmkdkqGqoUAA29fwi6KlEKjg6WzpSNHnmRZaU6HbsOR?=
 =?us-ascii?Q?UOxOEOKdM1nESwZlJs4GHCdUtxltXvj/Xx9yZz3FMskeeM3vsmYnDccWDa4H?=
 =?us-ascii?Q?Ba6RB3AQzu5U9tl5Kgq+crPbTO8pC/8LV57eN5HnkcYD3kQiROm5euZg/YNP?=
 =?us-ascii?Q?rxsJXYVNaFLloyChxMjcs+1ZtHzmxWtphVw29UQ2+TEEQPOxO3m2StS7U2iH?=
 =?us-ascii?Q?gbvu+h0aBA/V2dH1LIXkhCu2gzxXxVq6Z8V6en+yesqNNUYLfgaBz+J9C86U?=
 =?us-ascii?Q?49MinyX6qpXCrptI+vaZkP6FtdmL97DQMy9DguGjfjK+ASPlqSux8rBnQ/Rf?=
 =?us-ascii?Q?Xtik/jn+ArazmCvPx2fdvek4jrmjpmfGg8jbXX9TO+uQF9FJzJRinAJi4efQ?=
 =?us-ascii?Q?r3MIFG//7EHp3SiHDN4E9MT4cerqXMZRvWRavaaJbYIsHSW23HFbyW3206K5?=
 =?us-ascii?Q?nPPiOsh10dtq5uqg7XYhBS6HItl+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CSHwa8dzT7r4K+Rtqxh+ieNj/xIPCareWw95dTDmYcXiQaQnFE14Lynzq1kb?=
 =?us-ascii?Q?OPyhYDEj8qQ4kF3+LlPgVvayRb/ALeHBXEWMWpHANLq6fiddqlGXo+1fDXZm?=
 =?us-ascii?Q?182+rzojDvAallH2pnmnubc3vUmlT2zSRHdWyILsMTvJ5p4kjH5tAQ7tO69I?=
 =?us-ascii?Q?XinxsSsehltpNy1Nu2m+7f4utuKNJioMfK6Fz5QyKjoLYapVUz5OkQG6LQud?=
 =?us-ascii?Q?MZxyO+0R73tS8RoSRtIXRqM/x4+IGvmDmQ+SLVj/ckmLnIgRx9J4gENFNM4A?=
 =?us-ascii?Q?i15Fdzej8wIpVpaiaANEIsvtgbVxZfDVW21eRrEeOBgKk3wc6Mtr4eJYMsXc?=
 =?us-ascii?Q?iFgTbQGphmWNW1irp/LJ7lSIBNPkZ9HsciUwXI/c/xhluo5XZvTZBreqlsZX?=
 =?us-ascii?Q?32RA4RW9geWvSJga6K6mF1EvLLFl797iFeQHMCKhszNHRBmbPjTcTQDYXTgo?=
 =?us-ascii?Q?/nCaVbwQZ5UILzbq3tfVOvNlVHkd9QX5NgYQwRtxBDP2nsOU/34aweR52t8C?=
 =?us-ascii?Q?kuS2GNbmgaUA58IgPEKAIS7dngD89q/ydtJNEswUi13bFV8PlW7nIhx3Pj6w?=
 =?us-ascii?Q?90sTvQ1bNSMEVByv7oP9c/14x1SKWXSQ53v6Sic7zzl9NM3pqM5kuI5fneOJ?=
 =?us-ascii?Q?ENI3qgYEu8vfCfrRXWEt4cFDs3G8bMJC13PLDoqdobxCDdpNvuaVu4a0LNqH?=
 =?us-ascii?Q?xablpHpxkzlZaSs+vmexHlh7XdWqzywbOmfVzQqKupWtb1EhTTR37xTFEnNb?=
 =?us-ascii?Q?UME1t6BdOGQ43oWIi7CAaZTOMwA276iPIsLNwszjBtP9clLA/dkh7Thidzni?=
 =?us-ascii?Q?/sq3Qr12/kIO17L2h7v4h6ATttrLfHtYLzGWHIrIwtsbgWoVdSNMTu7IGgDe?=
 =?us-ascii?Q?h/Q8OyzESTOsY7sPQ0gr1WGEX2effInJsFX0c4q8y8py12H0h7L1sewF2s7b?=
 =?us-ascii?Q?G06ewMQNmI+LZdvQVZs4EK7pOEQSFe4zW40QBY/73MdweJOWzNKHxLErc4Eq?=
 =?us-ascii?Q?YZQprSUNkvez9LwHxF3TV42qNJPr86hR8MCrPtuoZhwFOcTwAhZmIl5tJv3S?=
 =?us-ascii?Q?OjSxMjKdY+J4R8aVJgAsz7KrT4uUu6wZh4CDFZkAoQlUkpN1eh9dEPSscJ/F?=
 =?us-ascii?Q?FWRCP1T6vKOd37hev3E+MhA7uKIx7GQdyM+fV+4DukHM+V9Z68iBW/iBSWMB?=
 =?us-ascii?Q?ntGSClXBi187p6uuz3871D6KI53Ts0UGM4ABE7/w/fTPLPh+CQLNneEDyYXp?=
 =?us-ascii?Q?w75wkNprv6IlKF5hJcH2TkST+siU84nLdtnFNr93ImgRVn5SM2hCqMX4Q8V1?=
 =?us-ascii?Q?1vwewDfAVJgXmvSy/MwTS515EopoZKSrv051CX003LCKZw3u12Ae9u1l+DbS?=
 =?us-ascii?Q?Kj65fUXM9L1rBedUitDYPcFql9v7n9+PhG/lxnqHmqYSTNRnEc273+Q1IZpl?=
 =?us-ascii?Q?FgaVO3fSAdwWFwjNAls7WYp5OVg/41HY8h2AWHprIqCzxEKGecZDjZWaMFHJ?=
 =?us-ascii?Q?sxAM0vuwY4HBKJL6wDMuNjgdMEo5zfhEGh6ijomZzjQTFbEygjEj5Xwv/baM?=
 =?us-ascii?Q?iNzRqUv8Rc+2kuzvfUt5cufgboWojJbw3PQEzQBCqApoNtHKpSAQyvGAM2UA?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27fb535e-630f-4fb7-b71c-08dd911e2a9b
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 06:28:10.7366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMy4AGBwS0cV8mB9FDtZ7pKEGdMuMv2RazGT/hpRA9skkF8pePsjCNIAb8JK6MQvGTR9PyRtx6+vXC7yHtpUGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7720
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.generic.094.fail" on:

commit: d1b0f9aa73fe50ee5276708e33d77c4e7054e555 ("bcachefs: Rework fiemap transaction restart handling")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

in testcase: xfstests
version: xfstests-x86_64-8467552f-1_20241215
with following parameters:

	disk: 4HDD
	fs: bcachefs
	test: generic-094



config: x86_64-rhel-9.4-func
compiler: gcc-12
test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz (Skylake) with 28G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202505121327.7f0fe895-lkp@intel.com

2025-05-11 07:30:51 export TEST_DIR=/fs/sda1
2025-05-11 07:30:51 export TEST_DEV=/dev/sda1
2025-05-11 07:30:51 export FSTYP=bcachefs
2025-05-11 07:30:51 export SCRATCH_MNT=/fs/scratch
2025-05-11 07:30:51 mkdir /fs/scratch -p
2025-05-11 07:30:51 export SCRATCH_DEV=/dev/sda4
2025-05-11 07:30:51 echo generic/094
2025-05-11 07:30:51 ./check generic/094
FSTYP         -- bcachefs
PLATFORM      -- Linux/x86_64 lkp-skl-d01 6.15.0-rc3-00024-gd1b0f9aa73fe #1 SMP PREEMPT_DYNAMIC Sun May 11 15:03:18 CST 2025
MKFS_OPTIONS  -- /dev/sda4
MOUNT_OPTIONS -- /dev/sda4 /fs/scratch

generic/094       - output mismatch (see /lkp/benchmarks/xfstests/results//generic/094.out.bad)
    --- tests/generic/094.out	2024-12-15 06:14:52.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//generic/094.out.bad	2025-05-11 07:31:04.283558895 +0000
    @@ -1,3 +1,11 @@
     QA output created by 094
     fiemap run with sync
    +ERROR: couldn't find extent at 241
    +map is 'DPPHDDHHPHPHHHHDHDHDPDDPDPPPHDDHDDPPHHDDHPDPDHPDHPDDHPPHDPHHPDHPDDPHPPPPDHDPHPHHPDHHDPHDPPDHDDDPPDPPPPPPPDPHDDPPDDPPHDDPDHPHPDPHHDPDHDDPDHDDDDHDPDDPDHHDHPPHPPPDPHPHHPPDHDDHDHDDHDHDPDPDHHPHDHHDHDDDDPHPDHDDHPPHHHPDDPHHDHDPPHDPDPDPHHPPDHPDPPDHDDPPPHPPHDHPPPPHHPPDPD'
    +logical: [     241..     241] phys:   417880..  417880 flags: 0x101 tot: 0
    +Problem comparing fiemap and map
     fiemap run without sync
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/094.out /lkp/benchmarks/xfstests/results//generic/094.out.bad'  to see the entire diff)
Ran: generic/094
Failures: generic/094
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250512/202505121327.7f0fe895-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

