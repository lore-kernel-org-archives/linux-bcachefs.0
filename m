Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90971859
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Sep 2024 03:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725160255; cv=none; b=HQ4me6MmCUpJ/rZcXgZEyQRNVrHRFxwY5mCiFSUQIkSuSNYIHrqrgZIqEAElhnUfeSPohh9UFEiOQ8n1e0wMo+aeZvLnrt0KgALzMQCv6cSvTIHcMyX83ytajDo+RS6+2+rfDhpEJzN9ZPBkqTfyeXwJ9kXIW2V5K90EeU+60QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725160255; c=relaxed/simple;
	bh=FwxIZRex5Vui30OMMsu6ewVKY5IxgFiXU9sBj2WfHqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYK+LMjBRgZp8Z516x+/K+7gIwhr3bOrcu4Smr8nFuuy07tWtMuzJzJ/AHQM9xfWZNEtJuURyCBBHETox1E+JnTQVG/Tv0WYAiyqoMSKezsIC9a8DIE8FsHjCBUmOFyfTTfHfeQiJVkVEZvKGJi7MMHRrY0d/YMthnT5hZayXMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qsXNrXA8; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qsXNrXA8"
Date: Sat, 31 Aug 2024 23:10:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725160250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0EUJtSRFCAfpCRJiBrMD8oHI7oveUz8hbHagGw45aU=;
	b=qsXNrXA8tXiHIw53Bk7NPTUKfEzdsCzrdnNVlplftfBZkX6UWpD4CqDJYQLpMKEQT9Cx2K
	IbrZRd8A6DOufF1I+XosVeVUiyn+0O1zOQPtHYb0k4gK+H3njmDqAuFEt9lapuLRXr1Skd
	DxQL0z2cxiGwxRKKS447rAdWZcXrpGE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix lost wake up
Message-ID: <viwjm5w7b7rwjewxn3aleluzkgttlc6j4cfcg4x7sadqtd65k2@plktedd7yfam>
References: <20240827151448.680522-1-mmpgouride@gmail.com>
 <hp2wa4k32nej5x5rgp6l2ffxsrdmgg2x5nxhuaqjzw7l24xmr3@pzticjr576mf>
 <8DC4157E-A12E-45FF-A3B4-F5DA1DC55A24@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8DC4157E-A12E-45FF-A3B4-F5DA1DC55A24@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Sep 01, 2024 at 10:50:37AM GMT, Alan Huang wrote:
> > 2024年9月1日 09:09，Kent Overstreet <kent.overstreet@linux.dev> wrote：
> > 
> > On Tue, Aug 27, 2024 at 11:14:48PM GMT, Alan Huang wrote:
> >> If the reader acquires the read lock and then the writer enters the slow
> >> path, while the reader proceeds to the unlock path, the following scenario
> >> can occur without the change:
> >> 
> >> writer: pcpu_read_count(lock) return 1 (so __do_six_trylock will return 0)
> >> reader: this_cpu_dec(*lock->readers)
> >> reader: smp_mb()
> >> reader: state = atomic_read(&lock->state) (there is no waiting flag set)
> >> writer: six_set_bitmask()
> >> 
> >> then the writer will sleep forever.
> >> 
> >> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> >> ---
> >> fs/bcachefs/six.c | 12 +++++++++---
> >> 1 file changed, 9 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
> >> index 3a494c5d1247..b3583c50ef04 100644
> >> --- a/fs/bcachefs/six.c
> >> +++ b/fs/bcachefs/six.c
> >> @@ -169,11 +169,17 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
> >> ret = -1 - SIX_LOCK_write;
> >> }
> >> } else if (type == SIX_LOCK_write && lock->readers) {
> >> - if (try) {
> >> + if (try)
> >> atomic_add(SIX_LOCK_HELD_write, &lock->state);
> >> - smp_mb__after_atomic();
> >> - }
> >> 
> >> + /*
> >> +  * Make sure atomic_add happens before pcpu_read_count and
> >> +  * six_set_bitmask in slow path happens before pcpu_read_count.
> >> +  *
> >> +  * Paired with the smp_mb() in read lock fast path (per-cpu mode)
> >> +  * and the one before atomic_read in read unlock path.
> >> +  */
> >> + smp_mb();
> > 
> > What is this barrier ordering?
> > 
> > This is only a change in the !try case, and we didn't do anything before
> > checking pcpu_read_count() - except way back in six_lock_slowpath()
> > where we set SIX_LOCK_HELD_write, but that does have a barrier.
> 
> Make sure six_set_bitmask(lock, SIX_LOCK_WAITING_read << type)
> 
> happens before pcpu_read_count()

that's in another thread, a memory barrier orders things in the same
thread
