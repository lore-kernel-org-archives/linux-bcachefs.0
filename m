Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97176D1B4
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 21:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337859; cv=none; b=je2pr3U+aLH0BdfGyYct5/Yi45qGZxqUC4MVwEgfFiEkFWQuhXRHvczMO2tFn/HyfLkc0NSfVsVn8nY3v8BmTJ6Lud6R3qiI+ndVU+aNpmW1s2NTxiR7J3SqbNaT7pOWGSw26nN3VT9U2uaiJxWboqDxCtAaKksn76QFKIUpJSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337859; c=relaxed/simple;
	bh=N9Fm15ZHn4sSi/OYXTG3vONh+AVr59xOARAhVbXD2Xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VnnA6z18UvoDNbjXaB1jcfr4JUkcLhqsdLZWX8lyLfPbi5b1kyD+z5WywG64hl6dmr6prH7UtGmKGPAx1ChpGDeWl0b62xwzdmYXL/nyfe3/9zF7wBFqoxivHWg90oyzaFnKc1WBtgHls9riP35sdhQ4mi/D9S5yj28j/kl4ZMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UoMjAzOH; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UoMjAzOH"
X-Envelope-To: cam.alvarez.i@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721337853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ciX05pLlsnOl0uE9Hgq1AUuDtPjPn53t8UiIVR/hqQk=;
	b=UoMjAzOHP58jaTQ77Xde0Cagxil7GN24MmHQ/8Os5HAnn5cGLZ6xScoPYuglc99wky+9n/
	7rAw9UT71sZKjS3+WT1/6irENC3Q6DnZIn5/Lg3qxHpgtnLuarfkXynw2Jhv95IkBOOyEG
	45mQ04Ou940POcjvP1NFGtLczSFpNj4=
X-Envelope-To: syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Thu, 18 Jul 2024 17:24:11 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Camila Alvarez <cam.alvarez.i@gmail.com>
Cc: syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com, 
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] bcachefs: WARNING in bch2_fs_journal_stop
Message-ID: <e2oi7a4jj4gjhzcp66rygr5d6wqlock6c5jvuwszxuej3hldmd@tnvbf45nbx2x>
References: <20240717220237.1246673-1-cam.alvarez.i@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240717220237.1246673-1-cam.alvarez.i@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 17, 2024 at 06:02:39PM GMT, Camila Alvarez wrote:
> last_seq and last_empty_seq suffered from an off by one error when the
> journal has no entries.
> 
> The indexes were fixed and an assertion is added to check that the
> last_empty_seq is always kept under the next valid seq number.

oh nice. I'm going to need to stare at this some more, I still feel like
this code needs to be clearer and less fiddly.

> 
> Reported-by: syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com
> Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
> ---
>  fs/bcachefs/journal.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
> index 10b19791ec98..7bbbf4b149e9 100644
> --- a/fs/bcachefs/journal.c
> +++ b/fs/bcachefs/journal.c
> @@ -1201,7 +1201,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
>  	struct journal_replay *i, **_i;
>  	struct genradix_iter iter;
>  	bool had_entries = false;
> -	u64 last_seq = cur_seq, nr, seq;
> +        u64 last_written_seq = cur_seq - 1, last_seq = cur_seq - 1, nr, seq;
>  
>  	genradix_for_each_reverse(&c->journal_entries, iter, _i) {
>  		i = *_i;
> @@ -1209,11 +1209,11 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
>  		if (journal_replay_ignore(i))
>  			continue;
>  
> -		last_seq = le64_to_cpu(i->j.last_seq);
> +		last_written_seq = le64_to_cpu(i->j.last_seq);
>  		break;
>  	}
>  
> -	nr = cur_seq - last_seq;
> +	nr = cur_seq - last_written_seq;
>  
>  	if (nr + 1 > j->pin.size) {
>  		free_fifo(&j->pin);
> @@ -1224,14 +1224,14 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
>  		}
>  	}
>  
> -	j->replay_journal_seq	= last_seq;
> +	j->replay_journal_seq	= last_written_seq;
>  	j->replay_journal_seq_end = cur_seq;
> -	j->last_seq_ondisk	= last_seq;
> -	j->flushed_seq_ondisk	= cur_seq - 1;
> -	j->seq_ondisk		= cur_seq - 1;
> -	j->pin.front		= last_seq;
> +	j->last_seq_ondisk	= last_written_seq;
> +	j->flushed_seq_ondisk	= last_seq;
> +	j->seq_ondisk		= last_seq;
> +	j->pin.front		= last_written_seq;
>  	j->pin.back		= cur_seq;
> -	atomic64_set(&j->seq, cur_seq - 1);
> +	atomic64_set(&j->seq, last_seq);
>  
>  	fifo_for_each_entry_ptr(p, &j->pin, seq)
>  		journal_pin_list_init(p, 1);
> @@ -1261,7 +1261,10 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
>  	}
>  
>  	if (!had_entries)
> -		j->last_empty_seq = cur_seq;
> +		j->last_empty_seq = last_seq;
> +
> +	WARN(j->last_empty_seq >= cur_seq, "journal startup error: last empty seq %llu is higher or equal than the next seq number to be used (%llu)",
> +	      j->last_empty_seq, cur_seq);
>  
>  	spin_lock(&j->lock);
>  
> -- 
> 2.34.1
> 
