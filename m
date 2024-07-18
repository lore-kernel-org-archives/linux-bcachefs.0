Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8D57E782;
	Thu, 18 Jul 2024 22:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721342582; cv=none; b=V9HnkJJ1bYPtUr4XKnCvEHPVqrXNTGct9cspu9bqAeXqQ4X5yu6tFoGQ9JwdnLCmPUXI5TAdfd4ysKUd0mSzV+UJXvRslpmv7SNcSm27YJgnX4cacWjRQ+NLGdDwa7TZGDEyHD+Zi52SeYquY7m81W1D9eauY8GKDEmnooFheU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721342582; c=relaxed/simple;
	bh=HpWlhzKg9e4nFacwyzP4uznvAoyCmftY8rNlzy9Bo1k=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=W2+KKZUDV0JPtruvUChxu1RznTbkbU5faESKBm7rohkh9jnslJOsLaUmXuwZYq/8w48OcegGsbsF/LCUYNm6qP2/mNm4/j3lPTkYF2AEARDGZMyow91eep68rwobyTwQqoMLjEIzz3fNNK9klCVuSBf6uiiLdaX38SHVvriSASA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TLHkd6+k; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TLHkd6+k"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7515437ff16so970454a12.2;
        Thu, 18 Jul 2024 15:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721342580; x=1721947380; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=v1/w1ipvFRHVeOsW7YLQPGt9GRyoNVOa6fKY5NmVljY=;
        b=TLHkd6+kyqEwEKU1Ctnjt9wrLqCLkqAuG9z0vg0d6SM+V4kEqvQFRzreKkEUBa2bKG
         qtrAnd/gpCUb8QHDh2nwRzwg5o63QZYngh1yK6bES6YL1G3v2OBkLpBEYAMn+DO3X2Jk
         Okc5tceUbqLUKVM2xy+GNg+0R6vNmuubkIMn/Lj2WQI4IgOONCUzBmTRifoQ78+oEYvX
         aHXPQQXWWTE6qcnnFX8I2kB7uomIYw4pE6vIjj1rEGPgsYN0hKxamyo9sfOcSDcJXmtM
         AJG7eUt08MpMnCVklasQf2QNPUhKQYUhGY7t3RIsbiyX5W8nRakL+/yo2/TZWXLT6nSG
         2EUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721342580; x=1721947380;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v1/w1ipvFRHVeOsW7YLQPGt9GRyoNVOa6fKY5NmVljY=;
        b=uCwdoKlvQUs3Hlh4BWzswXyc7uIOqIMoVj7xI1IH84lspxxpxS2jRkimwmSd20JhnJ
         eiwKdU9N+tRu74tFEhCEbIk0pqrbm+bdcEARazyAnbw3utJk1qrpq3kGo28w2oQzH/6L
         k4e24INv35FRbAFFht48ZwaPOxkIEmNPaW27oSra4A/MMbjsaKymbF89J62IzA1VJGGf
         wCxzfE5CZAC18V6Gv7QQfUr0Ou0pLFYiAVkCojs71nf2pWK25tplKxESa9D7yLsOogPW
         tbj6kRDHgRxkDiwbG2QGNY8grAd1g63gNoMjdczh0md+AGSebwGGREkU2B6Ix2ZZh797
         FLoQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/1RdMT717bR6i9WHBbBlfKNuYQJpHSkokhy6Wv0J+eYrm9S5VKug4VZyHIMVbMQf0MQI3FD6QlqvcM/Rzvg7BTK3RRaruSNmtMVBCP+nrR+RALC/G/TQ7sJI5A1oKCm25U59CJ5l5LKTZU+o=
X-Gm-Message-State: AOJu0Yx368gCSvlVI7Cp1JJplbhVOuSClLkVnKgsPdMenEYrfuxO5Kpp
	YnbUF35GUqAbDKRm3NFhntCDZClKZyzpjiNmVuQZOz+LsCzNt3uN
X-Google-Smtp-Source: AGHT+IHbpe3TiShjmlAl9l5NXvvNIycrl9UIW+g2AjfBb7sR7hIaXbRdyyucNnBft1RiJWgzlY3vXA==
X-Received: by 2002:a05:6a21:7899:b0:1bd:2894:4015 with SMTP id adf61e73a8af0-1c3fddeebc0mr8662521637.50.1721342580061;
        Thu, 18 Jul 2024 15:43:00 -0700 (PDT)
Received: from [2800:150:146:48c:849f:5012:675d:fc73] ([2800:150:146:48c:849f:5012:675d:fc73])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70cff4b0c34sm50288b3a.48.2024.07.18.15.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 15:42:59 -0700 (PDT)
From: Camila Alvarez Inostroza <cam.alvarez.i@gmail.com>
X-Google-Original-From: Camila Alvarez Inostroza <calvarez@macbook-pro-de-camila.local>
Date: Thu, 18 Jul 2024 18:42:55 -0400 (-04)
To: Kent Overstreet <kent.overstreet@linux.dev>
cc: Camila Alvarez <cam.alvarez.i@gmail.com>, 
    syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com, 
    Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
    linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] bcachefs: WARNING in bch2_fs_journal_stop
In-Reply-To: <e2oi7a4jj4gjhzcp66rygr5d6wqlock6c5jvuwszxuej3hldmd@tnvbf45nbx2x>
Message-ID: <6d42612b-1c20-0484-ce9f-eac509e6740d@macbook-pro-de-camila.local>
References: <20240717220237.1246673-1-cam.alvarez.i@gmail.com> <e2oi7a4jj4gjhzcp66rygr5d6wqlock6c5jvuwszxuej3hldmd@tnvbf45nbx2x>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed



On Thu, 18 Jul 2024, Kent Overstreet wrote:

> On Wed, Jul 17, 2024 at 06:02:39PM GMT, Camila Alvarez wrote:
>> last_seq and last_empty_seq suffered from an off by one error when the
>> journal has no entries.
>>
>> The indexes were fixed and an assertion is added to check that the
>> last_empty_seq is always kept under the next valid seq number.
>
> oh nice. I'm going to need to stare at this some more, I still feel like
> this code needs to be clearer and less fiddly.
>
Sure! Please let me know if there's anything I can do to help.
>>
>> Reported-by: syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com
>> Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
>> ---
>>  fs/bcachefs/journal.c | 23 +++++++++++++----------
>>  1 file changed, 13 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
>> index 10b19791ec98..7bbbf4b149e9 100644
>> --- a/fs/bcachefs/journal.c
>> +++ b/fs/bcachefs/journal.c
>> @@ -1201,7 +1201,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
>>  	struct journal_replay *i, **_i;
>>  	struct genradix_iter iter;
>>  	bool had_entries = false;
>> -	u64 last_seq = cur_seq, nr, seq;
>> +        u64 last_written_seq = cur_seq - 1, last_seq = cur_seq - 1, nr, seq;
>>
>>  	genradix_for_each_reverse(&c->journal_entries, iter, _i) {
>>  		i = *_i;
>> @@ -1209,11 +1209,11 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
>>  		if (journal_replay_ignore(i))
>>  			continue;
>>
>> -		last_seq = le64_to_cpu(i->j.last_seq);
>> +		last_written_seq = le64_to_cpu(i->j.last_seq);
>>  		break;
>>  	}
>>
>> -	nr = cur_seq - last_seq;
>> +	nr = cur_seq - last_written_seq;
>>
>>  	if (nr + 1 > j->pin.size) {
>>  		free_fifo(&j->pin);
>> @@ -1224,14 +1224,14 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
>>  		}
>>  	}
>>
>> -	j->replay_journal_seq	= last_seq;
>> +	j->replay_journal_seq	= last_written_seq;
>>  	j->replay_journal_seq_end = cur_seq;
>> -	j->last_seq_ondisk	= last_seq;
>> -	j->flushed_seq_ondisk	= cur_seq - 1;
>> -	j->seq_ondisk		= cur_seq - 1;
>> -	j->pin.front		= last_seq;
>> +	j->last_seq_ondisk	= last_written_seq;
>> +	j->flushed_seq_ondisk	= last_seq;
>> +	j->seq_ondisk		= last_seq;
>> +	j->pin.front		= last_written_seq;
>>  	j->pin.back		= cur_seq;
>> -	atomic64_set(&j->seq, cur_seq - 1);
>> +	atomic64_set(&j->seq, last_seq);
>>
>>  	fifo_for_each_entry_ptr(p, &j->pin, seq)
>>  		journal_pin_list_init(p, 1);
>> @@ -1261,7 +1261,10 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
>>  	}
>>
>>  	if (!had_entries)
>> -		j->last_empty_seq = cur_seq;
>> +		j->last_empty_seq = last_seq;
>> +
>> +	WARN(j->last_empty_seq >= cur_seq, "journal startup error: last empty seq %llu is higher or equal than the next seq number to be used (%llu)",
>> +	      j->last_empty_seq, cur_seq);
>>
>>  	spin_lock(&j->lock);
>>
>> --
>> 2.34.1
>>
>
