Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48D517C96
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 16:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732726662; cv=none; b=NJyWjPEVaeTg9LVB9fLdfjctOJOuK5mXj4jJOl7eISMbTZ9NLiS+0ZIP/RE10CwesxyhHeICuabKEB6KRliNfQyrcKSl6I63SNTTCRciMliMWWEsA8Jq112doNKhYwbbM/oOFWhktzni+FmDWltszUiOvtDUxKtX9zw1R8n91wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732726662; c=relaxed/simple;
	bh=zV8DAPljRgz7vNiJSquCmNtThDdjwLeq0i5+TJ0owsw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=h1Y0lBGuAMfhqVpsVGX2D3tg2hU8RjJM3CrBP/4TYMmNfy3ANWwYr+kfBhMyQ1rvsC2LQtew4mpHimis4eL7ClAwyQ734Tkv60gvHc/pYehAT2aXbuR0dgo6Wn/5YIoVOOrMiEYYgTprWYSIKDDnrRCsqjXsJHTX2zOhwy51oUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EVkoPE+I; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EVkoPE+I"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5cfc18d5259so11244a12.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 08:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732726659; x=1733331459; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zV8DAPljRgz7vNiJSquCmNtThDdjwLeq0i5+TJ0owsw=;
        b=EVkoPE+IPINN8wKj4d/569SiywVT16o+D18gx7jrLqvQPthBkjH3UgrFFd+WIbIzIF
         GMXKVV6uN/CLTNvvvBlh1+ecOXRDOpu+pJSu9idq79IfsiPuapeRhkLYdR0dm2i5ivRQ
         29eRQ8SU9vi547Ta7tkK+6tyZg4K4EAcOmt6chpl9M8Mvt8Re/yHe5oMM9gtdNYz6luy
         ptk3MPB8Z/7Xj3c8FvCHrdTbjBri/lPB+TdBUumM7PPcsGKmprBGQrS6kUnNtsLWMPPO
         K6qnYrsd/0DYTMpKfXgwqn3fdhigmlgZ2rfO9yxAmfHdjSGR6GSb7Q4lGNbXQcfgedar
         rv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732726659; x=1733331459;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zV8DAPljRgz7vNiJSquCmNtThDdjwLeq0i5+TJ0owsw=;
        b=TGPE6KjXLPsVSBIDj1nv3R8PSIM3pzX5fZPDQ7Y1Y75LmflSC61OreDHGMvab+hdoB
         VQJ2r75ZoGHeR8Y1f0fMNThuhN3m9ACNVlksUvIFUCZPdauOpI07NTUv1dKVwO163lrx
         bYJksW010Gx1wJK2A68Z/hs13osziGxJY6jwgikF1RHIL315Yk0jH4jO3EDqUiDMvyaw
         JhazFnVnXSEIGFQqHuGTBsN+EUjQxCdXTyxwEN2Uy6uDXMVY96cdQVvlcPj01LnAmIrb
         zgQJJwGwNsx7O4kN/tcajFvs22ZrsHx3BKC0h4kWeff7TV/O6m17G7ypTg+/8XciXwGq
         AU7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWhsXdjOEhUlJA2i3suPKEmJISLK/NewWJAxJ5SssUHCQuYFFXxRNAqaeSMiieg050GfZ+ri/vpHv9BOmy1Cw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1pYfaS9oKemI7QgwZPpTiSn4qGkbx9BQto1YZGbGAu/mxiXqu
	4NTGpONY0QbbIrURsFpe6BbmC/rZ3XDVpBfJdFsgllEHiQuXw+CWrO7CclkTJl2ZFqmCuQxF8cq
	bmfy29gaPbgWIxPxBAB/TTK/WuhgcapESXf+9MFVx1dVQ0c8WfFhRF6w=
X-Gm-Gg: ASbGncstl6AVsFYyKv1E/ehR/fTKSlJX1dw1IpvABh7E+Jx1ZtlVUxe66MCAP1bzHPq
	eMTvvuuCwM8yIPzcjjvOYRL+HfmPuKFE4MspXwbDKGNPRBI+oFpqNRPGxAQ4=
X-Google-Smtp-Source: AGHT+IGQ9jgicjt+kWH1dNUS0ZsDi3II7a3kom0Ep+yb8h5w/6qbGHt84K1Y7lvl5V6Y3Mq5BRi1R/n3oXlcmdvRKJo=
X-Received: by 2002:aa7:cd50:0:b0:5d0:f39:9c7 with SMTP id 4fb4d7f45d1cf-5d083570c07mr73959a12.7.1732726658907;
 Wed, 27 Nov 2024 08:57:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Wed, 27 Nov 2024 17:57:03 +0100
Message-ID: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
Subject: bcachefs: suspicious mm pointer in struct dio_write
To: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org
Cc: kernel list <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi!

In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
to an mm_struct. This pointer is grabbed in bch2_direct_write()
(without any kind of refcount increment), and used in
bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
which are used to enable userspace memory access from kthread context.
I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
guarantees that the MM hasn't gone through exit_mmap() yet (normally
by holding an mmget() reference).

If we reach this codepath via io_uring, do we have a guarantee that
the mm_struct that called bch2_direct_write() is still alive and
hasn't yet gone through exit_mmap() when it is accessed from
bch2_dio_write_continue()?

I don't know the async direct I/O codepath particularly well, so I
cc'ed the uring maintainers, who probably know this better than me.
