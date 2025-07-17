Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF9D2F85F6
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Jul 2025 15:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752766038; cv=none; b=JqGP6pwD5hpDMNOokiChpwUA16eXdZRo22QxN/aOV8dYHTNogS6S3qiuavuLwysRIRX8iICiNPwxyWi7TeJDy2eH/un7lzpKQcE/LegBnFkVntDAZeZwC4XlhxtLFydebsH7C6YdofckfoWiFkUnw6eO0oYhj4wU3Mv32vo2+nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752766038; c=relaxed/simple;
	bh=7J8G45oQ4xeHh2ss0tQfrgjUhUJeRkbjYgyqO9ubUeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S6FFnbhiAlo95ylcC+8/EAucaGxF7FS9fNXS3hiz5kim7CnUQyFg0yTHI0K/iOYowDLW8z/Kzwf7mxKIA47bit8utfPRnlK4+NnCLGsZqmJ2KsxKbwJU29RvKrbu8MoC7pDfn9EYwVGImLVW+/knariXNg/hXJOs/HvrkER1J0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xq8sSTHl; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xq8sSTHl"
Date: Thu, 17 Jul 2025 11:27:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752766023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9dyCGmJt2sMCnlxw4U6M8uVDnpaSdcG0TbGVGnHlhHY=;
	b=xq8sSTHloH6O64xc2vwGgurL+uEeiVlwKDu+snmZLqtRQbR1H0AEZjCuDDCyilC6ITfr8l
	uvKOM7+SynwWJL9K++exzgsExwg5TUti4OPx9TXzECCG6qKwVgakEEp8PSuDX4TccSlMzA
	A8BIrMTIyOMGogFl+jKidm59HEElaOE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, lkp@intel.com, 
	oe-kbuild-all@lists.linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [linux-next:master 10097/10441]
 fs/bcachefs/journal_reclaim.c:877 journal_flush_done() warn: missing error
 code? 'ret'
Message-ID: <wdeo6locp7sa2fyuyr2mukq7bg6snlw7nk5atr74kd3yhpnjoq@sy5zecuqoykf>
References: <3008994f-e84d-4763-a4db-9666555ce33f@suswa.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3008994f-e84d-4763-a4db-9666555ce33f@suswa.mountain>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 17, 2025 at 05:32:20PM +0300, Dan Carpenter wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   e8352908bdcd2d0bcf0aca8c69fae85fd5ea5edb
> commit: 0e1d28c378988f28b773807c00e7f3be40f49bf3 [10097/10441] bcachefs: convert journal_reclaim.c to CLASS/guards
> config: i386-randconfig-141-20250716 (https://download.01.org/0day-ci/archive/20250717/202507171850.10rxb3uq-lkp@intel.com/config)
> compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202507171850.10rxb3uq-lkp@intel.com/
> 
> smatch warnings:
> fs/bcachefs/journal_reclaim.c:877 journal_flush_done() warn: missing error code? 'ret'
> 
> vim +/ret +877 fs/bcachefs/journal_reclaim.c
> 
> 039fc4c5221f74 Kent Overstreet 2020-05-28  861  static int journal_flush_done(struct journal *j, u64 seq_to_flush,
> 039fc4c5221f74 Kent Overstreet 2020-05-28  862  			      bool *did_work)
> 1c6fdbd8f2465d Kent Overstreet 2017-03-16  863  {
> 35f5197009cae2 Kent Overstreet 2025-01-25  864  	int ret = 0;
> 1c6fdbd8f2465d Kent Overstreet 2017-03-16  865  
> 1c6fdbd8f2465d Kent Overstreet 2017-03-16  866  	ret = bch2_journal_error(j);
> 1c6fdbd8f2465d Kent Overstreet 2017-03-16  867  	if (ret)
> 1c6fdbd8f2465d Kent Overstreet 2017-03-16  868  		return ret;
> 1c6fdbd8f2465d Kent Overstreet 2017-03-16  869  
> 0e1d28c378988f Kent Overstreet 2025-07-14  870  	guard(mutex)(&j->reclaim_lock);
> 000de45996c4b0 Kent Overstreet 2019-01-14  871  
> 1e690efa72596a Kent Overstreet 2025-02-10  872  	for (int type = JOURNAL_PIN_TYPE_NR - 1;
> 1e690efa72596a Kent Overstreet 2025-02-10  873  	     type >= 0;
> 1e690efa72596a Kent Overstreet 2025-02-10  874  	     --type)
> 1e690efa72596a Kent Overstreet 2025-02-10  875  		if (journal_flush_pins_or_still_flushing(j, seq_to_flush, BIT(type))) {
> 35f5197009cae2 Kent Overstreet 2025-01-25  876  			*did_work = true;
> 0e1d28c378988f Kent Overstreet 2025-07-14 @877  			return ret;
> 
> I think ret was intended to be the return value from
> journal_flush_pins_or_still_flushing()?

It is a bit unusual, but not a bug.

If journal_flush_pins_or_still_flushing() returns true, then the flush
hasn't complete and we must return 0; we want the outer
closure_wait_event() in journal_flush_pins() to continue.

The early return is there because we don't want to call
journal_entry_close() until we've finished flushing all outstanding
journal pins - otherwise seq_to_flush can be U64_MAX, and we'll close a
bunch of journal entries and write tiny ones completely unnecessarily.

Having the early return be in the loop where we loop over types is
important, because flushing one journal pin can cause new journal pins
to be added (even of the same type, btree node writes may generate more
btree node writes, when updating the parent pointer has a full node and
has to trigger a split/compact).

This is part of our shutdown sequence, where order of flushing is
important in order to make sure that it terminates...

Applying this...

diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index be50455c7f13..f23e5ee9ad75 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -874,7 +874,34 @@ static int journal_flush_done(struct journal *j, u64 seq_to_flush,
 	     --type)
 		if (journal_flush_pins_or_still_flushing(j, seq_to_flush, BIT(type))) {
 			*did_work = true;
-			return ret;
+
+			/*
+			 * Question from Dan Carpenter, on the early return:
+			 *
+			 * If journal_flush_pins_or_still_flushing() returns
+			 * true, then the flush hasn't complete and we must
+			 * return 0; we want the outer closure_wait_event() in
+			 * journal_flush_pins() to continue.
+			 *
+			 * The early return is there because we don't want to
+			 * call journal_entry_close() until we've finished
+			 * flushing all outstanding journal pins - otherwise
+			 * seq_to_flush can be U64_MAX, and we'll close a bunch
+			 * of journal entries and write tiny ones completely
+			 * unnecessarily.
+			 *
+			 * Having the early return be in the loop where we loop
+			 * over types is important, because flushing one journal
+			 * pin can cause new journal pins to be added (even of
+			 * the same type, btree node writes may generate more
+			 * btree node writes, when updating the parent pointer
+			 * has a full node and has to trigger a split/compact).
+			 *
+			 * This is part of our shutdown sequence, where order of
+			 * flushing is important in order to make sure that it
+			 * terminates...
+			 */
+			return 0;
 		}
 
 	if (seq_to_flush > journal_cur_seq(j))
