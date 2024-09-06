Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5539F1D1F60;
	Fri,  6 Sep 2024 15:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637481; cv=none; b=lYy2aR2EJ2luPOTxPfIuwSTFE77AqPYKJIk4wNhL7vvYsajUy8nR3hpUAQEz4uQLS+1oeiv+rP5pRVBFhRajX0dp4aiZRbyNlcobK2ecE3wfTrHIFcS0GcpTTjaC1ki6pe1Q9lp4a+3Uxpo5BX7H12LbyclWW1IImBt4k6esbZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637481; c=relaxed/simple;
	bh=ZvPFD8bPKG1etjMtBkCrFyLUx7SmSfqtAsFtfAF+cx4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kT/stet79T4Cimph0UtnKPP175QjDLg8cZPuVc9WK5/R79Wfss0a8Jor+L9Vuyhq5EFf7YOg6fy03oE7sxEURI6Jz/L8fGvv2RK2wuM2GpRG98Vwy/PKEbgevtR1BQmfx9OV9RrwA350VObNSRwnfuDtANz0C3VfcVUZtie7hWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=iI6lpr+z; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="iI6lpr+z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Vn/aY
	4/1WDYl2eiuTqp/va7eYXiS8/ytS0g6RbDVMU0=; b=iI6lpr+zlRyawnvHWnANw
	cRHTymyuaYuPA0HU108UT6xecX1kXephVm+7LBlChKVWK754v1XZFAcf6TWgXQNf
	o3O+25dtlnwU1oXgbNWzSod4tLpdaEy+OkQlGAaR6lsJPZqtns0x2HxiAoWtJRWK
	xQik30pWOQ4myZdzbBIkBg=
Received: from localhost.localdomain (unknown [111.35.190.113])
	by gzga-smtp-mta-g3-2 (Coremail) with SMTP id _____wD3f6U7I9tmL+v1Hg--.60435S4;
	Fri, 06 Sep 2024 23:44:15 +0800 (CST)
From: David Wang <00107082@163.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG?] bcachefs performance: read is way too slow when a file has no overwrite.
Date: Fri,  6 Sep 2024 23:43:54 +0800
Message-Id: <20240906154354.61915-1-00107082@163.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3f6U7I9tmL+v1Hg--.60435S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxur1UGryxGF18Cr4Dtr18Krg_yoW5Cr13pF
	WY9340yrZ8Xrn5Cws0y34UKF18Jw15Jay5WF10gr42gF95XFy3KaySkay5JrWDuFW7Ww1U
	tFZ2vryUAF1qv3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UD739UUUUU=
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/1tbiqRNSqmVOCtKGQgAAs1


Hi,

I notice a very strange performance issue:
When run `fio direct randread` test on a fresh new bcachefs, the performance is very bad:
	fio --randrepeat=1 --ioengine=libaio --direct=1 --name=test  --bs=4k --iodepth=64 --size=1G --readwrite=randread  --runtime=600 --numjobs=8 --time_based=1
	...
	Run status group 0 (all jobs):
	   READ: bw=87.0MiB/s (91.2MB/s), 239B/s-14.2MiB/s (239B/s-14.9MB/s), io=1485MiB (1557MB), run=15593-17073msec

But if the files already exist and have alreay been thoroughly overwritten, the read performance is about 850MB+/s,
almost 10-times better!

This means, if I copy some file from somewhere else, and make read access only afterwards, I would get really bad performance.
(I copy files from other filesystem, and run fio read test on those files, the performance is indeed bad.)
Copy some prepared files, and make readonly usage afterwards, this usage scenario is quite normal for lots of apps, I think.


I made some profiling, when read the file without any overwritten to it:

	io_submit_one(98.339% 2635814/2680333)
	    aio_read(96.756% 2550297/2635814)
		bch2_read_iter(98.190% 2504125/2550297)
		    __bch2_read(70.217% 1758320/2504125)
			__bch2_read_extent(74.571% 1311194/1758320)
			    bch2_bio_alloc_pages_pool(72.933% 956297/1311194)  <-----This stands out
			    submit_bio_noacct_nocheck(11.074% 145207/1311194)
			    bio_alloc_bioset(3.823% 50126/1311194)
			    bch2_bkey_pick_read_device(2.157% 28281/1311194)
			    bio_associate_blkg(1.668% 21877/1311194)
				...

And when the file was thoroughly overwritten, by a previous readwrite FIO session, the profiling is:

	io_submit_one(97.596% 12373330/12678072)
	    aio_read(94.856% 11736821/12373330)
		bch2_read_iter(94.817% 11128518/11736821)
		    __bch2_read(70.841% 7883577/11128518)
			__bch2_read_extent(35.572% 2804346/7883577)
			    submit_bio_noacct_nocheck(46.356% 1299974/2804346)
			    bch2_bkey_pick_read_device(8.972% 251601/2804346)
			    bio_associate_blkg(8.067% 226227/2804346)
			    submit_bio_noacct(7.005% 196432/2804346)
			    bch2_trans_unlock(6.241% 175020/2804346)
			    bch2_can_narrow_extent_crcs(3.714% 104157/2804346)
			    local_clock(1.873% 52513/2804346)
			    submit_bio(1.355% 37997/2804346)
				...

Both profilings have sample 10-minutes duration, and same sample frequency.
Base on the difference between total sample count, 2680333 vs 12678072,
 I would suspect bch2_bio_alloc_pages_pool would incur lots of locking.

Here more detail for bch2_bio_alloc_pages_pool:

	bch2_bio_alloc_pages_pool(72.933% 956297/1311194)
	    alloc_pages_mpol_noprof(82.644% 790323/956297)
		__alloc_pages_noprof(89.562% 707833/790323)
		    get_page_from_freelist(79.801% 564855/707833)
			__rmqueue_pcplist(24.713% 139593/564855)
			post_alloc_hook(15.045% 84983/564855)
				...
		    __next_zones_zonelist(3.578% 25323/707833)
			...
		policy_nodemask(3.352% 26495/790323)
			...
	    bio_add_page(10.740% 102710/956297)



Thanks~
David

