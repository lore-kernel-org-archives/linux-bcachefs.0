Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB1515FD01;
	Mon, 27 May 2024 19:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837946; cv=none; b=szDGwibaNz+cLFIZxNAoM1F6RQGIYua9GL4n5KpEkATH63Dj+ooTcih0Qp55Cql4ewXHXp7M/+eY8jBJCRq2MeMUm5pICENFTzGFeqNM3csZJpY6Tvu5siMyScQZd5sR2AzGbvcV5rt3Eemc3RK8H6aXGNF6OMnVBVhMOtamkmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837946; c=relaxed/simple;
	bh=UWZElWnD/lEhDgW78Wemug8QZpdfZGoVTj/8LI3lFiw=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qi++BucriJPGrskLB7LC01AWeVHykaNmNYCvQRY3ZwLoUYXJ19/qMfWDKjrwXjG3lgD8K1vCtF09Xl1xTOmYukx/+NTG3HnNjPpWw0A/Pw8A1ms9jfh6tCAyPhHl15MLBEUOemvDyzYiNr7Sl4yiKxskYzLsFl0i100SE6TGTLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NWwI9mCG; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NWwI9mCG"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5b5254f9c32so39071eaf.0;
        Mon, 27 May 2024 12:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716837944; x=1717442744; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=q6CNvLtiL3EHElRY2cknRBZ6IFenXiy2KNmFEpcwP0s=;
        b=NWwI9mCGgbC5NQlCMUqQcFUXLBR1XfUurHsfEFN6zT+4oTof4+NwvTOHRKzOtdNTUh
         +F9AbzIpSjmudKeB71sxD/dmY0vHHazsAY7Flmhv4DQHwziePxyUylhEs9vsPejN+Qcf
         2QwSqmI35I+XmE4JUM2VfcDaVFzBd2sWo7I0dcy9kh6KGp0Sk8As17/qnSrX+dxFxIjs
         rhi3ch5NiKXhvbDyy5ctTD9hzO3irpSK9wxlp6Zi6GmNJNiZ9nQKefrEesCANys3pt0f
         AaWQ7Swl/2b53485kt+gTE0uORDvTLWwneDKHY1KAh2d/9twj64bGlX3HHjLNoDBDEOw
         8TqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716837944; x=1717442744;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q6CNvLtiL3EHElRY2cknRBZ6IFenXiy2KNmFEpcwP0s=;
        b=EIJyCCmDU3ugycdvZRHEV0Fk130DpK0XDRuqmM7bqA3XdXZPRx9zuPiu8S78/BVnA1
         sAiOSM/ZlXn1tU+PDAGrsPChRX8hh8B6agK8BhbPc8si7QUWpvMfYkpQjpEk+fTc+h6a
         N+SUPuSwwkGxnGLlZPFX+1Px6Actxj4DoGAtVXqYF+8eZTnqMXI41sFLQVEc8Lapvv75
         8nwTtVJ3z4jB1j8netRqnrtObUYGl2nylSr7FqAVcilb4sx3pcgs6TQ5fv5lwjnXfuD5
         rncTbpPktvOPao8KSk3eg7FM9equGGUO9D4EoeqyLEMyaXxjoB4Mkl0G2YMa486Xzh4M
         JYSg==
X-Forwarded-Encrypted: i=1; AJvYcCV0EOqRfflKHQ04G4sPxA22YRvsUbWF22P0N+YMFnO7Zign2yfdo2zsStLRSIgZ3bFLbFEdv+YFvvuW3nDUQExbl9ZJNrYNdkjBNtIaQGQ8ImcdPW/U/wys+fGYCn7cL+QHB7ITiPgTB5epkQM=
X-Gm-Message-State: AOJu0YwG+30p4mdWNA8co7DD53KbLvSstXzeFNcicQzYQrmcookbD2/g
	kurOtj6rBn6Ez1MqDepykN/yw5Qko8jJUH6oOGEGKQWGnU6wJ3Er
X-Google-Smtp-Source: AGHT+IE58+7Q47AWd+tVl2XmoD/fm6I4o4+xbJG/gABpSkQz1T6eU1JQ6xwfdK4Bk16/DZzkGI9nyw==
X-Received: by 2002:a05:6358:2826:b0:194:6301:a71c with SMTP id e5c5f4694b2df-197e510cd08mr1282664855d.16.1716837944145;
        Mon, 27 May 2024 12:25:44 -0700 (PDT)
Received: from [192.168.7.110] ([190.196.103.34])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6822189158bsm6269634a12.24.2024.05.27.12.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 May 2024 12:25:43 -0700 (PDT)
From: Camila Alvarez Inostroza <cam.alvarez.i@gmail.com>
X-Google-Original-From: Camila Alvarez Inostroza <calvarez@macbook-pro-de-camila.local>
Date: Mon, 27 May 2024 15:25:39 -0400 (-04)
To: Camila Alvarez <cam.alvarez.i@gmail.com>
cc: Kent Overstreet <kent.overstreet@linux.dev>, 
    Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
    linux-kernel@vger.kernel.org, 
    syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] bcachefs: fix last_seq and last_empty_seq in
 bch2_fs_journal_start()
In-Reply-To: <20240520025733.688425-1-cam.alvarez.i@gmail.com>
Message-ID: <cf7d1a86-b1e4-08ee-0d99-0b3f2823fb47@macbook-pro-de-camila.local>
References: <20240520025733.688425-1-cam.alvarez.i@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hello,
I was wondering if you had had the time to take a look at this.
Please let me know if there's something I'm missing.

Thanks!

On Sun, 19 May 2024, Camila Alvarez wrote:

> Values were left as the next possible sequence number when there were no
> entries.
>
> The fix involves updating the last_seq initial value and
> setting last_empty_seq to cur_seq - 1.
>
> Reported-by: syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com
> Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
> ---
> Changes in v2:
> - Introduce a new variable to distinguish the last sequence number, from
>  the last written sequence number
> - Abstract `cur_seq - 1` into a variable named `last_seq`
> - Reference to the last sequence number are changed from `cur_seq - 1`
>  to `last_seq`
> ---
> fs/bcachefs/journal.c | 22 +++++++++++-----------
> 1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
> index adec8e1ea73e..99fc32f0382d 100644
> --- a/fs/bcachefs/journal.c
> +++ b/fs/bcachefs/journal.c
> @@ -1195,8 +1195,8 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
> 	struct journal_entry_pin_list *p;
> 	struct journal_replay *i, **_i;
> 	struct genradix_iter iter;
> -	bool had_entries = false;
> -	u64 last_seq = cur_seq, nr, seq;
> +	bool had_entries = false;
> +	u64 last_written_seq = cur_seq - 1, last_seq = cur_seq - 1, nr, seq;
>
> 	genradix_for_each_reverse(&c->journal_entries, iter, _i) {
> 		i = *_i;
> @@ -1204,11 +1204,11 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
> 		if (journal_replay_ignore(i))
> 			continue;
>
> -		last_seq = le64_to_cpu(i->j.last_seq);
> +		last_written_seq = le64_to_cpu(i->j.last_seq);
> 		break;
> 	}
>
> -	nr = cur_seq - last_seq;
> +	nr = cur_seq - last_written_seq;
>
> 	if (nr + 1 > j->pin.size) {
> 		free_fifo(&j->pin);
> @@ -1219,14 +1219,14 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
> 		}
> 	}
>
> -	j->replay_journal_seq	= last_seq;
> +	j->replay_journal_seq	= last_written_seq;
> 	j->replay_journal_seq_end = cur_seq;
> -	j->last_seq_ondisk	= last_seq;
> -	j->flushed_seq_ondisk	= cur_seq - 1;
> -	j->seq_ondisk		= cur_seq - 1;
> -	j->pin.front		= last_seq;
> +	j->last_seq_ondisk	= last_written_seq;
> +	j->flushed_seq_ondisk	= last_seq;
> +	j->seq_ondisk		= last_seq;
> +	j->pin.front		= last_written_seq;
> 	j->pin.back		= cur_seq;
> -	atomic64_set(&j->seq, cur_seq - 1);
> +	atomic64_set(&j->seq, last_seq);
>
> 	fifo_for_each_entry_ptr(p, &j->pin, seq)
> 		journal_pin_list_init(p, 1);
> @@ -1256,7 +1256,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
> 	}
>
> 	if (!had_entries)
> -		j->last_empty_seq = cur_seq;
> +		j->last_empty_seq = last_seq;
>
> 	spin_lock(&j->lock);
>
> -- 
> 2.34.1
>
>
