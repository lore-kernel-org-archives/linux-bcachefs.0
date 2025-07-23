Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA617AD4B
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Jul 2025 10:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753264845; cv=none; b=jwG9bz+PSHEXvXE3h+MZGnUpM7zG/90M4N4sdKTW4TKtY1XM2K5AELv30Bl043bcyj+j/ZDqgOHrH9lW9JjF+Y7Zrvm/jMK5FybHU4+kngmwToqmOyP02+94YSU6XfVS5BPjwpLR+Xv2FABWBRD74F1gUSBR/aDlzW2Vye+v4uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753264845; c=relaxed/simple;
	bh=HPZwATo2v7l2HKnBADp1hY9EvYt/2s2FvfAZXn5KMgo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k+D7dOS/CtDQqwwxvzjD9Y6e/aO7Hn0a4gz8bYFWxUMqXKWG6gBmugQzWJG9P3JaifFYXPOFqcOZft2w/7Zry/QHlkyNaXO5crgCqdzPEwuwtb1ma8pEMrTacswf3p8JgRBcViC6xPqKd5kaKkQxTKjrxaSFG0MEUhg8eBNzUWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ayGFd5cL; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ayGFd5cL"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3122368d7c4so5500638a91.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Jul 2025 03:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753264843; x=1753869643; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HPZwATo2v7l2HKnBADp1hY9EvYt/2s2FvfAZXn5KMgo=;
        b=ayGFd5cL3R3LoL/zdxpCk7+lUry2dJIAnit4piWTrOUcabWqWOyMcg0/8oQduUf18u
         MIdeeQhnXgqg8PBeChU5pHpDYfMGcMzSDatDWMiEDjdMp+XI/SjjWqqm6yNYkarseP57
         o8LytKX7r4zJBFJ1vUtjdfZODT2N9RCVoUngGqCyJB5E+oD3hCYZOMuxbkS4idwGYZID
         4LNR2tyH4/cheSmGNr8eEeD/SaNbUqnQ3D0x6XDiX3SftHTog7u5Y/vdMBkgYexH1qMF
         myDaYUu9fErPad0f6dTB4vL/CIiia0P0rmGuYLJt1tyaxg/ogzaSxDdSukIVdfNz4y+v
         nd3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753264843; x=1753869643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HPZwATo2v7l2HKnBADp1hY9EvYt/2s2FvfAZXn5KMgo=;
        b=AKAPa0EKFFLriZyv5d0rzrcGpkfcQqg20NBd1jajNN2eOSvfzHmWGFJdnf2+QGYdAV
         JrC4ki9j6GOFAi3/yLRUUpEdzVlvcFvepOLOLjxLDrg4IRIhvqBENrkB41We8vVpVFuK
         +vq+f1ZJe+B84gUdd19RFhSWLMrLnaruRpZ9WgDluff7+b0LE76h119l4NZXNtW5EBEn
         l1h8nkE371a0o+hniUvF2iT5c6qT/OK6MTDqki1d9V8m4zQsX1xHpwfXEIC/0cexcDUH
         P6PeKJuoJEG8+pFiJbqaypiU7F/wuXEx/bN7BhEE5OHk7nC5ABl/r4A9D0w/Qq+T3e8e
         8BQg==
X-Forwarded-Encrypted: i=1; AJvYcCW7SsCsF7tlPywNKE/247TIjfM1cYAQEdJ4EFq6gzu48BQNwykEd0xuRhQPWy0pqaSv/g9iINgg06PfixnpAg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzTpAn02YQmt9Oi8AJZrewXLIcuohWgRbJHz7NZEuQnso3blp9l
	+rxXS09bqBRWefxtnUDA8RVmO1FO2x+dOG/gA6kH4Of68MZD/JpmA8IpQcRNj/6i/xMC8UKWkk1
	NnRjdYv5ec8uzIzIlweWMI3iiC9ZRLz8OPauVE8AI
X-Gm-Gg: ASbGncu3u0sRkXgIIJt3i7uex+4g4d+yAijjX09wufkZgxBfrMtwXxvtwvrI5Rtj6ri
	5BGri2DR74b6ht0ZqUTGzY3I4MGin7Qk6DFNcHemD+yuE0GGjd5deLk9/ysVfx3vsilgyupSlHV
	o//x2ufSlQI7FVl7jjDYMX8sc0J1Ochav+ASv0uVdqiXDyjCQ6VMTsNSdZER/m6iHFR6nYudmcw
	fSulZdbq2HAvttxCoj9T1Dan9Wo+rzVSsU=
X-Google-Smtp-Source: AGHT+IFKdgMVv6MdZ6th8VYi+G1eSJ+usUdsbGov5YnyFODN1/ouqeIDAQd3Vhyn+lwAM/oVscstn/wc15yDdHf9Va8=
X-Received: by 2002:a17:90a:d004:b0:30a:4874:5397 with SMTP id
 98e67ed59e1d1-31e5076975dmr3527915a91.9.1753264842865; Wed, 23 Jul 2025
 03:00:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <687a71bf.a70a0220.693ce.006b.GAE@google.com> <nxgsgizgeja6265rgz3uezzpgy33toz7aiicwy6uf5g5orhbcj@qmqipkujhg5c>
In-Reply-To: <nxgsgizgeja6265rgz3uezzpgy33toz7aiicwy6uf5g5orhbcj@qmqipkujhg5c>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 23 Jul 2025 12:00:29 +0200
X-Gm-Features: Ac12FXzuflPvvUMLvR1nQ6j-JAG-PFzkYytPhhrcjQwHerDhhO2eoYNb1CHvQtw
Message-ID: <CANp29Y4K9fU_QFye5E-J00PvY8FcCGtRFotY1yUAa8TmKFwsPQ@mail.gmail.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Write in bch2_get_next_dev
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: syzbot <syzbot+2b98caf09c41174a9697@syzkaller.appspotmail.com>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2025 at 7:35=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> Will syzbot reopen if the fix is still in linux-next? Let's find out.
>
> #syz fix: bcachefs: Fix UAF by journal write path
>

Syzbot will actually "close' the bug only once the fix commit has
reached all the fuzzed trees. So it should be okay.
