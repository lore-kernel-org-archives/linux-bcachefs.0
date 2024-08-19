Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEFD4EB38;
	Mon, 19 Aug 2024 15:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724080672; cv=none; b=YhiCyxhlJ9z9+Zb7x2FOzBUiRTzOSaE8H23lgg4ePJKFM7zkJ+OMg1DgIu4L96/1gNYitjGzoI4KcsmINdqP+ZnNBO5iw97/sJHL/BOmx/NfKX4s9PYDUgFnimBDhL2xOdIKdB8NB98kTgvCucEXPwNrzOu7Xoc4qlZ/18XtQ1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724080672; c=relaxed/simple;
	bh=mkTCGq2+1aSfwLXdPG5/078ftqbnfz5IVxvOhv3syUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ImVLak5Mt1bfIsGcskK1nP+9Z64j9r/AczZJ71Xamne/MzFaQMvV7ThkXV0Rh/fN33zW97/GJ/whAQEIEcPvaduibmSbxuBrfPCPpNaI7xoo3uGIaGl+gXLSG4B9+Ip3eqTPKhsrB+y6doyY+dRMJqx5r8nYKjclWBfRFyBtwPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RNi4VT/0; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RNi4VT/0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724080671; x=1755616671;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mkTCGq2+1aSfwLXdPG5/078ftqbnfz5IVxvOhv3syUU=;
  b=RNi4VT/0pK7iiYZvsLQLbdE+0v64yma1gzPj59k768cXfARb2aXpFHuq
   13FSNQE7/F4/X1+4pWUJLTbrIRIPNFIY3fsaiXNnMvOGMgYvWcnHo2H1A
   U5cOfnC30R3ymYxbDfuQK0cUwy8pADdnXg7rjv208oyA158Xn0RdCJJpC
   5TdEON+UF+KxoXpfKBUAIam5G8eIztLM/JxSIy1S09z1Mvp3vDmFJBhIx
   Izzx/yO5PSAh/ljsC63fNzgmzEKFDyXxG5zfY097sqnwuQYd471njovOV
   QO7UsKsh4JF7L3MYPgchBltXcGyxTnguu9ldqBuyH6Wcls84IHDG0W52r
   A==;
X-CSE-ConnectionGUID: hhdhzNJ1TPSRlHKwqZXiRw==
X-CSE-MsgGUID: 7YGAmmA8TzG4mRnEJpsnag==
X-IronPort-AV: E=McAfee;i="6700,10204,11169"; a="26201819"
X-IronPort-AV: E=Sophos;i="6.10,159,1719903600"; 
   d="scan'208";a="26201819"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2024 08:17:50 -0700
X-CSE-ConnectionGUID: qg6M0GTMS7S3LueENvsLmw==
X-CSE-MsgGUID: bwKcB7YoSYOagBFtT56AkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,159,1719903600"; 
   d="scan'208";a="64803975"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 19 Aug 2024 08:17:48 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sg48f-000976-39;
	Mon, 19 Aug 2024 15:17:45 +0000
Date: Mon, 19 Aug 2024 23:17:35 +0800
From: kernel test robot <lkp@intel.com>
To: Lizhi Xu <lizhi.xu@windriver.com>,
	syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] bcachefs: Fix oob in bch2_dev_journal_init
Message-ID: <202408192244.CGhqCzQ3-lkp@intel.com>
References: <20240819064754.35606-1-lizhi.xu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819064754.35606-1-lizhi.xu@windriver.com>

Hi Lizhi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.11-rc4 next-20240819]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lizhi-Xu/bcachefs-Fix-oob-in-bch2_dev_journal_init/20240819-145031
base:   linus/master
patch link:    https://lore.kernel.org/r/20240819064754.35606-1-lizhi.xu%40windriver.com
patch subject: [PATCH] bcachefs: Fix oob in bch2_dev_journal_init
config: arm-randconfig-003-20240819 (https://download.01.org/0day-ci/archive/20240819/202408192244.CGhqCzQ3-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240819/202408192244.CGhqCzQ3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408192244.CGhqCzQ3-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/bcachefs/journal.c:1317:6: warning: format specifies type 'unsigned long' but the argument has type '__u64' (aka 'unsigned long long') [-Wformat]
    1316 |                                 prt_printf(&buf, "journal v2 entry d[%u].nr %lu overflow!\n", i,
         |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                                                                             %llu
    1317 |                                         le64_to_cpu(journal_buckets_v2->d[i].nr));
         |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/byteorder/generic.h:87:21: note: expanded from macro 'le64_to_cpu'
      87 | #define le64_to_cpu __le64_to_cpu
         |                     ^
   include/uapi/linux/byteorder/little_endian.h:33:26: note: expanded from macro '__le64_to_cpu'
      33 | #define __le64_to_cpu(x) ((__force __u64)(__le64)(x))
         |                          ^
   fs/bcachefs/util.h:78:54: note: expanded from macro 'prt_printf'
      78 | #define prt_printf(_out, ...)           bch2_prt_printf(_out, __VA_ARGS__)
         |                                                               ^~~~~~~~~~~
   1 warning generated.


vim +1317 fs/bcachefs/journal.c

  1297	
  1298	int bch2_dev_journal_init(struct bch_dev *ca, struct bch_sb *sb)
  1299	{
  1300		struct journal_device *ja = &ca->journal;
  1301		struct bch_sb_field_journal *journal_buckets =
  1302			bch2_sb_field_get(sb, journal);
  1303		struct bch_sb_field_journal_v2 *journal_buckets_v2 =
  1304			bch2_sb_field_get(sb, journal_v2);
  1305	
  1306		ja->nr = 0;
  1307	
  1308		if (journal_buckets_v2) {
  1309			unsigned nr = bch2_sb_field_journal_v2_nr_entries(journal_buckets_v2);
  1310	
  1311			for (unsigned i = 0; i < nr; i++) {
  1312				ja->nr += le64_to_cpu(journal_buckets_v2->d[i].nr);
  1313				if (le64_to_cpu(journal_buckets_v2->d[i].nr) > UINT_MAX) {
  1314					struct bch_fs *c = ca->fs;
  1315					struct printbuf buf = PRINTBUF;
  1316					prt_printf(&buf, "journal v2 entry d[%u].nr %lu overflow!\n", i,
> 1317						le64_to_cpu(journal_buckets_v2->d[i].nr));
  1318					bch_info(c, "%s", buf.buf);
  1319					printbuf_exit(&buf);
  1320					return -BCH_ERR_ENOMEM_dev_journal_init;
  1321				}
  1322			}
  1323		} else if (journal_buckets) {
  1324			ja->nr = bch2_nr_journal_buckets(journal_buckets);
  1325		}
  1326	
  1327		ja->bucket_seq = kcalloc(ja->nr, sizeof(u64), GFP_KERNEL);
  1328		if (!ja->bucket_seq)
  1329			return -BCH_ERR_ENOMEM_dev_journal_init;
  1330	
  1331		unsigned nr_bvecs = DIV_ROUND_UP(JOURNAL_ENTRY_SIZE_MAX, PAGE_SIZE);
  1332	
  1333		for (unsigned i = 0; i < ARRAY_SIZE(ja->bio); i++) {
  1334			ja->bio[i] = kmalloc(struct_size(ja->bio[i], bio.bi_inline_vecs,
  1335					     nr_bvecs), GFP_KERNEL);
  1336			if (!ja->bio[i])
  1337				return -BCH_ERR_ENOMEM_dev_journal_init;
  1338	
  1339			ja->bio[i]->ca = ca;
  1340			ja->bio[i]->buf_idx = i;
  1341			bio_init(&ja->bio[i]->bio, NULL, ja->bio[i]->bio.bi_inline_vecs, nr_bvecs, 0);
  1342		}
  1343	
  1344		ja->buckets = kcalloc(ja->nr, sizeof(u64), GFP_KERNEL);
  1345		if (!ja->buckets)
  1346			return -BCH_ERR_ENOMEM_dev_journal_init;
  1347	
  1348		if (journal_buckets_v2) {
  1349			unsigned nr = bch2_sb_field_journal_v2_nr_entries(journal_buckets_v2);
  1350			unsigned dst = 0;
  1351	
  1352			for (unsigned i = 0; i < nr; i++)
  1353				for (unsigned j = 0; j < le64_to_cpu(journal_buckets_v2->d[i].nr); j++)
  1354					ja->buckets[dst++] =
  1355						le64_to_cpu(journal_buckets_v2->d[i].start) + j;
  1356		} else if (journal_buckets) {
  1357			for (unsigned i = 0; i < ja->nr; i++)
  1358				ja->buckets[i] = le64_to_cpu(journal_buckets->buckets[i]);
  1359		}
  1360	
  1361		return 0;
  1362	}
  1363	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
