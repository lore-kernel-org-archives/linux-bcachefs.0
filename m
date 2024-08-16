Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A2116F0E1
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 11:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723809353; cv=none; b=h3TuoBu3TvHkd2hhU5q1d47RE0dSf/IcxNiQKVRMbBjUCmdE4Q892ztuu4FiBotXndRzYZ638WSlh2wX4z74CLnuqPTdG3foWEzSZl5/nzPmC6eudHrg+nZR3r5rG2YWRZSzq8blDx4yA7hMnWmYbtJ0bPEwLE9U8zXnaVGyGYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723809353; c=relaxed/simple;
	bh=hFHwlYbImRVWuo3+gr7BN/RPoODUYvgbt1hoLHQ7mo4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fhtIisUpbMhYFFkwVgfyHTz5ful5k3d5CK0IS6lB3Yn0BYIjCHHRbBayqnskVMmRxR41hmH0wwSepR7pugDqApzWgVPw0Bp9IKSaE+9DaDSnWBb1q8FEJn/GbLOpk+rtzyllA7O0MmFzl9ApjH8N5D5iipHJrrjqH+bNwFQbQQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=cOTM7tZW; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="cOTM7tZW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1723809347;
	bh=JK2ZEGKF5wUVngvJcuzrxy5s4hF6B4QBRkWO2T8fN14=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=cOTM7tZWaasIp1kq7AiZ+im9Cw1jkBHytjEgXK+aD45QJ38VX6mAaF1RmThmj1xLv
	 O1oYjl0L21nJWGQRqPayxsg6DXPSvBnG+zd5Sw83uYmoeRHWe/SuJ6MOuJdJLVt/su
	 xUKrfRdluFTdmGDL7qrOg01TdZjQ2y+UBmixQPlXG02P+kkQs1qGx/MJJOynynXFl/
	 DWwrld8VHANDtnSQ4p5hdtnREFmEOhkCBtekf6Virvmf8r+EZV6mY7ClHVfsIKotm+
	 oNhB2Rlth2qbdDFT+I+Vqj88P3dfwiBVBK3vZwQGYP4sZ8zaxLbU4HpH5cxi8Mossc
	 TEz42c1x7SKhA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4WlgRl39kVz4wp0;
	Fri, 16 Aug 2024 21:55:47 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Erhard Furtner <erhard_f@mailbox.org>, linux-bcachefs@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Subject: Re: 'do_IRQ: stack overflow: 1072' at using bcachefs partition
 (ppc32, kernel 6.10.5)
In-Reply-To: <20240815125651.3189da31@yea>
References: <20240815125651.3189da31@yea>
Date: Fri, 16 Aug 2024 21:55:46 +1000
Message-ID: <87v8003cn1.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Erhard Furtner <erhard_f@mailbox.org> writes:
> Greetings!
>
> Basically bcachefs works on ppc32 but I get stack overflows like this one rather easy:
>
> [...]
> do_IRQ: stack overflow: 1072
> CPU: 1 PID: 2114 Comm: bash Not tainted 6.10.5-gentoo-PMacG4 #1
> Hardware name: PowerMac3,6 7455 0x80010303 PowerMac
> Call Trace:
> [effe3fc0] [c0785664] dump_stack_lvl+0x70/0x8c (unreliable)
> [effe3fe0] [c00081fc] __do_irq+0x28/0x80
> [effe3ff0] [c000873c] __do_IRQ+0x7c/0x84
> [c8aec430] [c8aec610] 0xc8aec610
   ^ 
That's your lowest frame on the process stack. It should actually extend
down to c8aec000, so you had a little bit of space left.

CONFIG_DEBUG_STACKOVERFLOW warns when you have less than 1/4 of the stack
free. You could try turning it off and see if the system survives.

The other thing to try would be increasing the THREAD_SHIFT to 14.

cheers
