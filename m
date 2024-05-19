Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30124501B
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 May 2024 18:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716143121; cv=none; b=rkMINtySeLG5qou6kUiJrAis4b1TILyc7Pp7/9WsNIKodvNlKlYXgjsJDGlwEadRtt7kaqoVrIZZnMnnhMtwhsJ8JlX1aF3tFlBfHOFvtpytM0uvWpHJDbrLFYHQUp4C/gay6C2KVP03I20i/PAIsg106p/yj+iofY//LUxCdgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716143121; c=relaxed/simple;
	bh=BPkMiBJmFbqc3tij2Xd3XOMpsHnYCTRsmbhkmPPLLfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LbjuWi8slXERaugxZiHmwxuXZ8VW+wZChUUtRFxEVRiOiVlYvYGSZtGjvZ3eDs+bgtB3NMrUqr1YtHhIoptN0cyymokwwUhSqRTZ2aSv79iteRNuEtpV86VUURyfLtOWd4aXKPqdITl3px6tAgCdDk9QqN7gt0fgJnHU+VUMC84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eb7nYwoJ; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eb7nYwoJ"
X-Envelope-To: cam.alvarez.i@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716143113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CZcRqAT2Hi9yDWO8AgOOTA1HMWZQbltFlns+P+hoiOI=;
	b=eb7nYwoJyvWNoWkYNPH+CFyEFJ0HVytomFWb0PeZC2uSgdpleQWs4IDXu2+bLMzWv2jguS
	DP4iRbeMl6da1jVTYnhei4eHdYUjzWoYlos8Yf+f8IaymOQVhGVbF+pTTwPGFeZUbYDoCv
	QlejPHzVPF2le/OP2jsHfXKI9WHo3AY=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com
Date: Sun, 19 May 2024 14:25:09 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Camila Alvarez <cam.alvarez.i@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: fix last_seq and last_empty_seq in
 bch2_fs_journal_start()
Message-ID: <c7qpzaeqhyvkbgaplvazj6steii5ayta7gtidmy24u7gfnnkuc@nhc2swhzmuff>
References: <20240516031919.592696-1-cam.alvarez.i@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240516031919.592696-1-cam.alvarez.i@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 15, 2024 at 11:19:20PM -0400, Camila Alvarez wrote:
> Values were left as the next possible sequence number when there were no
> entries.
> 
> The fix involves updating the last_seq initial value and
> setting last_empty_seq to cur_seq - 1.

I think this is correct, but we should try to come up with some better
assertions or something to make the code clearer; we don't want off by
ones to lurk so easily.

Could you give it some thought?

> 
> Reported-by: syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com
> Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
> ---
>  fs/bcachefs/journal.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
> index adec8e1ea73e..3835c458eec9 100644
> --- a/fs/bcachefs/journal.c
> +++ b/fs/bcachefs/journal.c
> @@ -1196,7 +1196,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
>  	struct journal_replay *i, **_i;
>  	struct genradix_iter iter;
>  	bool had_entries = false;
> -	u64 last_seq = cur_seq, nr, seq;
> +	u64 last_seq = cur_seq - 1, nr, seq;
>  
>  	genradix_for_each_reverse(&c->journal_entries, iter, _i) {
>  		i = *_i;
> @@ -1256,7 +1256,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
>  	}
>  
>  	if (!had_entries)
> -		j->last_empty_seq = cur_seq;
> +		j->last_empty_seq = cur_seq - 1;
>  
>  	spin_lock(&j->lock);
>  
> -- 
> 2.34.1
> 
