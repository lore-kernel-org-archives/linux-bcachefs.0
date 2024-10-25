Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D941C7B79;
	Fri, 25 Oct 2024 09:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729850033; cv=none; b=ZPEvB0jCIYcdW9wZbw+Lw0C7ZTiOAGqk9CWVDWFFkSY5gZ4PUFG7dnNleG5QIAmHuJF6vRqg8cD1Zr/LSHnK5RSQQ7eMIQv84XDQ/MxIZLgUs0JODDT4H3xw7qXBlabd/gErXVAxko/AF14d8A9hWZAlvg2olW/Ah8HVGWAB4g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729850033; c=relaxed/simple;
	bh=W5EQbHTC6EziqGrCsV7nFc+6r14CHxbg0BJscd8yHJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dd/oDb/yZAvN2ZvXoK6bgsuSf0I6PHObj+hBcK3wk4FotPDmrtiXJQBcCI8oBI5jkWgVvQaBUJfEtemWiYHHznGjvEfoSmRRom/+HfGvVTqnbmCoqaOv/LwPKzK5oeQfWJz6d3lmLJGZUj1kcdchLEwMTuOkPrio6wrwmbbLcg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=USPL3rpC; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="USPL3rpC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729850032; x=1761386032;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W5EQbHTC6EziqGrCsV7nFc+6r14CHxbg0BJscd8yHJQ=;
  b=USPL3rpCJ4SCQZHm+xliou75MjU9jz83eNTR925GDeDPoW9xnFGKYuLq
   Yx5fOEvjPAQhcTFJR9YXZlzV9nUtSfRsfR6/qcaX0I+xomG2hrQLeYWwe
   rEFTLWeyv1LV3faUjQPBgEgn67AiyqUbCEpj0ofunyKWwouNu0R/93/L7
   TE4l6xtDwed7NUU1yT/FnyTph+0wTQJ03bjn1SJGlI84HoRYJp0EmIlZv
   XOLiXfJFB2CtJH2uX3NfTI+vjzuar9nGU63s/fFVLyRD2Wf11cpa3wZ27
   K845HzFJnaObYHdzikWNI3358QJlq5c2+JGY70AjfPOO5oV9p1bw88L1C
   A==;
X-CSE-ConnectionGUID: gLwlJBE0TwuzNtSXQbXzDA==
X-CSE-MsgGUID: 0/UPtWGZSkSQHJNa41K00w==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="54916912"
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="54916912"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2024 02:53:51 -0700
X-CSE-ConnectionGUID: D4XZ1wtrQHyLHkgqq15yhg==
X-CSE-MsgGUID: xhQSCP+KTruksCryxb/9pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="80879699"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.161.23])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2024 02:53:50 -0700
Date: Fri, 25 Oct 2024 17:52:57 +0800
From: "Lai, Yi" <yi1.lai@linux.intel.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [Syzkaller & bisect] There is INFO: task hung in
 __rq_qos_throttle
Message-ID: <ZxtqeYRHz3hQrR0f@ly-workstation>
References: <ZxYsjXDsvsIt4wcR@ly-workstation>
 <kuvbuekbzs6saggfxleiaqtl5mleozqozpamivz2zo6pd4istq@c6hfl6govn44>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kuvbuekbzs6saggfxleiaqtl5mleozqozpamivz2zo6pd4istq@c6hfl6govn44>

On Wed, Oct 23, 2024 at 09:57:53PM -0400, Kent Overstreet wrote:
> On Mon, Oct 21, 2024 at 06:27:25PM +0800, Lai, Yi wrote:
> > Hi Kent Overstreet,
> > 
> > Greetings!
> > 
> > I used Syzkaller and found that there is INFO: task hung in __rq_qos_throttle in v6.12-rc2
> > 
> > After bisection and the first bad commit is:
> > "
> > 63332394c7e1 bcachefs: Move snapshot table size to struct snapshot_table
> 
> You sure...?
> 
> Look at the patch, that's a pretty unlikely culprit; we would've seen
> something from kasan, and anyways there's guards on the new memory
> accesses/array derefs.
> 
> I've been seeing that bug too, but it's very intermittent. How did you
> get it to trigger reliably enough for a bisect?

Look into my local bisection log. You are right, that the bug is intermittent
and takes a very long time to reproduce the issue.

I didn't observe similar issues during following v6.12-rcx kernel
fuzzing. I will keep monitoring.

Regards,
Yi Lai
