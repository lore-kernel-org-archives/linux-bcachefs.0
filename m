Received: from andre.telenet-ops.be (andre.telenet-ops.be [195.130.132.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41619482E9
	for <linux-bcachefs@vger.kernel.org>; Mon, 24 Jun 2024 08:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.132.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719218260; cv=none; b=pJsBEVPecVHQPn2X92HZekQd/NYPmzQ5+Hiv1W9ILwtOEYGZoaIDKLsz6LKFJFY+k5L0mYMKIos3eXRCGU7QEQlEDLDbVxv3qscvVR5y8ZrVAGZ8cU90k0/KR7d/B2s1sw8RMZfUZXlrzcinUVk5zUxmOenfJtnEw51Z0NoDMvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719218260; c=relaxed/simple;
	bh=+igET6cJtEQ07pMG4h28A/64M0JqpbtIvvlIfD8W0ps=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ixyIDkBQuomFx5S0it28ENO+FfK9t6s+4cMtrgcPSTExggP+f2w+pAHYuroNv3cBW2dCOSj/6dWpE9DURz0pZY2lpyeoFGdSwRNqXimDZIytSJOiWblUyJNj8XEl0bhv69iMhntqoPkOjA6DHj9yNeqlqglzjSxWzRZK56pKrOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.132.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:d11f:2bfd:8d32:701a])
	by andre.telenet-ops.be with bizsmtp
	id fLdc2C00A4jBKfC01Ldc4Q; Mon, 24 Jun 2024 10:37:36 +0200
Received: from geert (helo=localhost)
	by ramsan.of.borg with local-esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1sLfCi-000Gg7-Dq;
	Mon, 24 Jun 2024 10:37:36 +0200
Date: Mon, 24 Jun 2024 10:37:36 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
cc: linux-bcachefs@vger.kernel.org
Subject: Re: Build regressions/improvements in v6.10-rc5
In-Reply-To: <20240624082656.1092500-1-geert@linux-m68k.org>
Message-ID: <7e86a151-11c7-b89-62a5-50cb8b7612c6@linux-m68k.org>
References: <CAHk-=wiMMT-2pfJZ8ckbnGTbSHy5mvvE=+-MyA_ARPUqiy_C1w@mail.gmail.com> <20240624082656.1092500-1-geert@linux-m68k.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 24 Jun 2024, Geert Uytterhoeven wrote:
> JFYI, when comparing v6.10-rc5[1] to v6.10-rc4[3], the summaries are:
>  - build errors: +1/-3

   + /kisskb/src/fs/bcachefs/data_update.c: error: the frame size of 1028 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]:  => 336:1

m68k-gcc8/m68k-allmodconfig

> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/f2661062f16b2de5d7b6a5c42a9a5c96326b8454/ (132 out of 138 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/6ba59ff4227927d3a8530fc2973b80e94b54d58f/ (133 out of 138 configs)

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
