Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FED524DF
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 Feb 2024 07:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709191267; cv=none; b=t0RQj2d17ECAq5rYnDhXuqaCFMZgJptmPuXzVJXoJoRR5D/xYrm+3r/QaYR5wGm5iQYFfIExcqKIyb+p/bwU++M31YVtBgQYqINjeCvf2SdcuBxdWTzO8EdNZUjKocK8FLi0LRQi4t+OGJtzXipVBu6uq3/1tP5LADl5xbpFqFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709191267; c=relaxed/simple;
	bh=4BWkix83xa69Td6GkY4u4awSoBX+UEzZGygqWJSpHls=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uN2DWfa9jJStMkKks/ulxDg6IQXOEBwAgvUtk0kRNv5by9UP2oyfX8LqxiYn/zJJUI463gi3cPMTBZzx/00nSI9NfdL9T6PpciqKREKhWkHYoYHl70VcPgnn1mid5jPYFOmF5Vi+LslHh8dkd+BVbiZEDGKGlkyO3cedUCv3nNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QbwcDjEI; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QbwcDjEI"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a3d5e77cfbeso98156866b.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 28 Feb 2024 23:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1709191263; x=1709796063; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GEAakXwp+X35NpPg8nElFXY9Bau6mxbRPajKEZaxeiQ=;
        b=QbwcDjEIBITPcuAGwuwCtVwcMv0cKekSfml+cTZPU9Rc6ZfHlWkGX0fSaaEAk9dJ05
         ZBYaMinD3R5ZYewVb41lqDjQ/RIuVyV/8VddIj7igDBmQtN1EZ5zSGNxpc48modOTJ6c
         B8QdeqQdv3OhBLbwKuxEc+/CgtwccMnukvkUw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709191263; x=1709796063;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GEAakXwp+X35NpPg8nElFXY9Bau6mxbRPajKEZaxeiQ=;
        b=VQIbXtkQTU28tSOvrhLfA7QnvQrlj2n3Zgh3E9EyYyVAKSwpwielMboL8q5XD7cy4J
         QGc4+JazNsZ4lwFUXG4lLtxUEa0NTgyrZ65e9eW9bGPkDEWL3ERLct81OnRu6uDu0Ydr
         tc/+sZZMYAsWDmVwGJ12l5lqirqS5U2l+KyHvUIyyVXxIuTD5vjrTecpQyoGBtIG53vw
         lubHqX7BdJQNyBchN9Ch6m1Rtuxtp4eIjszAEhkx4A3NM59UktrXyPR8U7Az5pxVV2wC
         Jf9sjIrA0+OBDs/V0HLY2oy0NsIUUKLLYAE9C3IrDyYqAmMVwhFiBijLhvpFtwTtzNz/
         B9Ng==
X-Gm-Message-State: AOJu0Yzf6ZjhDHg4zk2z12ByR4Q90+QJW/IRo5lGVm923HHmctvIenwG
	B4zL/iXWdjvYRti0+Bjl2sKr25vDO2BCZlA35msxnGVaLPMxv/R8/h2+NfHN/MZEJ5X6e5zzx4c
	pF03UiQ==
X-Google-Smtp-Source: AGHT+IEouT8gKAwBQK1dB5FujW4omnnMxsc+I5+f9QD/FBO8/OpZIyQMhXSBSR+WT6XELxIdzGrxGg==
X-Received: by 2002:a17:906:a0d3:b0:a44:2779:6faf with SMTP id bh19-20020a170906a0d300b00a4427796fafmr686780ejb.36.1709191262958;
        Wed, 28 Feb 2024 23:21:02 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id ub13-20020a170907c80d00b00a4406929637sm376026ejc.162.2024.02.28.23.21.02
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 23:21:02 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a3d5e77cfbeso98152766b.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 28 Feb 2024 23:21:02 -0800 (PST)
X-Received: by 2002:a17:907:aa9:b0:a44:2cc3:2ba8 with SMTP id
 bz9-20020a1709070aa900b00a442cc32ba8mr685150ejc.27.1709191261969; Wed, 28 Feb
 2024 23:21:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229063010.68754-1-kent.overstreet@linux.dev> <20240229063010.68754-3-kent.overstreet@linux.dev>
In-Reply-To: <20240229063010.68754-3-kent.overstreet@linux.dev>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Feb 2024 23:20:44 -0800
X-Gmail-Original-Message-ID: <CAHk-=whf9HsM6BP3L4EYONCjGawAV=X0aBDoUHXkND4fpqB2Ww@mail.gmail.com>
Message-ID: <CAHk-=whf9HsM6BP3L4EYONCjGawAV=X0aBDoUHXkND4fpqB2Ww@mail.gmail.com>
Subject: Re: [PATCH 2/2] bcachefs: Buffered write path now can avoid the inode lock
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	david@fromorbit.com, mcgrof@kernel.org, hch@lst.de, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 28 Feb 2024 at 22:30, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Non append, non extending buffered writes can now avoid taking the inode
> lock.

I think this is buggy.

I think you still need to take the inode lock *shared* for the writes,
because otherwise you can have somebody else that truncates the file
and now you will do a write past the end of the size of the file. That
will cause a lot of issues.

So it's not a "inode_lock or not" situation. I think it's a
"inode_lock vs inode_locks_shared" situation.

Note that the reading side isn't all that critical - if a read races
with a truncate, at worst it will read some zeroes because we used the
old length and the page cache got cleared in the meantime.

But the writing side ends up having actual consistency issues on disk.
You don't want to have a truncate that removes the pages past the end
of the new size and clears the end of the new last page, and race with
another write that used the old size and *thought* it was writing to
the middle of the file, but is now actually accessing a folio that is
past the end of the whole file and writing to it.

There may be some reason that I'm missing that would make this a
non-issue, but I really think you want to get the inode lock at least
shared for the duration of the write.

Also note that for similar reasons, you can't just look at "will I
extend the file" and take the lock non-shared. No, in order to
actually trust the size, you need to *hold* the lock, so the logic
needs to be something like

 - take the lock exclusively if O_APPEND or if it *looks* like you
might extend the file size.

 - otherwise, take the shared lock, and THEN RE-CHECK. The file size
might have changed, so now you need to double-check that you're really
not going to extend the size of the file, and if you are, you need to
go back and take the inode lock exclusively after all.

Again - I haven't thought a ton about this, so maybe there's some
trick to it, but the above is what my naive thinking says the rule has
to be. Writes are different from reads.

              Linus
