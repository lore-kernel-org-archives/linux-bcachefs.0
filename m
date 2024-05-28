Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B2D17BD6
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 May 2024 03:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716866327; cv=none; b=pxz1Z8RLlraRN5DjJoaIWnMVHpMG+Dsqc9ihRpk2sdNqgxC3/oMuTf78EecLmNAZ2OZo53XBEgAf4BlCW1DfEC62uhPmI/S4yjgNPiskbwn+c0yZ5hrZgX1aZpe6a/5AYU2FfQuPvOA+L56Qma7GIOvNOOrl7/0VoghmJfoTo30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716866327; c=relaxed/simple;
	bh=VYFfSvOpMeDCGiOoSm+qVlswYhROO8b0d+kxyyCiUck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hoHbWjmV0l4NqYRkkbdLqRqPbYoEZ8jKD70PxJxLjGTlhHw4fEn6zh06GTu3Mq72B7KJmuFcer93xRHPQW2vbKtP8YNbhFjX88b+Te7ElasCWoa3lJ20eHJhPuq932ARECG0V1JgSA0L8I8SaDGDrIbx7TSy32VQ4xbsm8OP4tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cSBhfM/X; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cSBhfM/X"
X-Envelope-To: cam.alvarez.i@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716866323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VYFfSvOpMeDCGiOoSm+qVlswYhROO8b0d+kxyyCiUck=;
	b=cSBhfM/X9ctdend3W+PJYjIOoS4LuAB9XcGNmbXDpyS0y55ASrR5fYfk1neh+9Rzrpbadr
	LgPV3QtHg6TUfSrDicKctOeVYK27lznoD28InKPbHXoDUhL0k/sg972IOcEMsQP64iaE3q
	JtDkojDBYmH7KH7E793A6zRcOLKRViE=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com
Date: Mon, 27 May 2024 23:18:40 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Camila Alvarez Inostroza <cam.alvarez.i@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] bcachefs: fix last_seq and last_empty_seq in
 bch2_fs_journal_start()
Message-ID: <adcv7g23gfc65wlwavgrfxr6wnjua5qp5jp5i66srwjizwzgiy@fg5ahzm5gp6m>
References: <20240520025733.688425-1-cam.alvarez.i@gmail.com>
 <cf7d1a86-b1e4-08ee-0d99-0b3f2823fb47@macbook-pro-de-camila.local>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf7d1a86-b1e4-08ee-0d99-0b3f2823fb47@macbook-pro-de-camila.local>
X-Migadu-Flow: FLOW_OUT

On Mon, May 27, 2024 at 03:25:39PM -0400, Camila Alvarez Inostroza wrote:
> Hello,
> I was wondering if you had had the time to take a look at this.
> Please let me know if there's something I'm missing.

Sorry, I'll get to it - I'm going to need to stare at this one and try
and figure out what the assertions should be
