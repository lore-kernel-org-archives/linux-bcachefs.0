Received: from mail.tnxip.de (mail.tnxip.de [49.12.77.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269C1376
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 23:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.77.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742252771; cv=none; b=C4pcHZKypAuslRD9EpruPlfpQwA1a5ot7r91Z6MIbxoY39FGFe6VH7IahDF0BKkBRLrdqfocERNN5C/wKjiVD5vMyKfYFyhrGIEsnfYV0qNcK+vweB5qIPFOyafr4K7ReWEp6Mf1g3aC9GlO1ZxBY20DHHhzTDV1wh+37EF1ooo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742252771; c=relaxed/simple;
	bh=awETql4BkG8xWKmUNvS4nNAi67lekcrRu5ytiVA9YLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PoeMhtVSuCOnHUvo6tyFEWLhkUc5t2+ggQt1Apzz3UiPqHkxSy+lok0/MnB4e95aDEIIoclSRAKKkrq+xjs0Os3ylwHJ+dR7knroTbLm2qzARvwq4Umq3L99q064JAm+0QrT4WGJ/lSl3cdWXX1vI6Rm9UcN7B0X6wzS+JRr+h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de; spf=pass smtp.mailfrom=tnxip.de; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=1meybzMg; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=cskKexQQ; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=eJRSchDt; dkim=neutral (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=UVFlIUsd; arc=none smtp.client-ip=49.12.77.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tnxip.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="1meybzMg";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="cskKexQQ";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="eJRSchDt";
	dkim=neutral (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="UVFlIUsd"
Received: from gw.tnxip.de (unknown [IPv6:fdc7:1cc3:ec03:1:e2f1:6dd1:57c5:794d])
	by mail.tnxip.de (Postfix) with ESMTPS id 78871208B2;
	Mon, 17 Mar 2025 22:48:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-vps;
	t=1742248112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1UyW2F8rd25OUZ81ptThOaXGu3a9zwN2CoP4yeUxJBY=;
	b=1meybzMgJMD63qmyB7YfvdtIbrYkXkVkHoDFSTJXzhuViC1r5f1PuDNtCwLnrzdviVgZRL
	B7F9PkHY5s7E1TJTP73+x7gT3N/tOtuj+EcGC1NwAI34bBgUgEkuz1DQLSLca4ZdjDNw1k
	LYo8P4km4BxzkxTIsV7D0ty5EJM6SiM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-vps-ed; t=1742248112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1UyW2F8rd25OUZ81ptThOaXGu3a9zwN2CoP4yeUxJBY=;
	b=cskKexQQwPqyxhkNKzV8lgPUlGgyEkneBjYmM9nRtdfP6PFIj/yjj+L3eoGWvXvUeP+m5V
	wpxBnC+Eb4cXskDQ==
Received: from [IPV6:2a04:4540:8c0e:7400:7ad6:a016:a57e:722] (unknown [IPv6:2a04:4540:8c0e:7400:7ad6:a016:a57e:722])
	by gw.tnxip.de (Postfix) with ESMTPSA id 383DE5800000000000628;
	Mon, 17 Mar 2025 22:48:26 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-gw-ed; t=1742248112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1UyW2F8rd25OUZ81ptThOaXGu3a9zwN2CoP4yeUxJBY=;
	b=eJRSchDtfG88XVRwB6nQ1L7YlCeiO84bz+Lx9v98HRaCyjcJ745xjY4Erq1lOcJjXBLeYP
	DEXBHJDeMbKugVAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-gw;
	t=1742248112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1UyW2F8rd25OUZ81ptThOaXGu3a9zwN2CoP4yeUxJBY=;
	b=UVFlIUsddSKGDShvajYlGg7jKTVaoKMzamMvc630c5OqS0N8w1SrY2CgKEKNuJ4Fv0XdFF
	8iQakdRf1KZw+ElKzQ/YVkMMIfcXl0DIGCT6pkcXsIYP4V4spQxKE6KB52OVz9l/4t+uM0
	Rw8B+T/MKXRio4zWIWuacqgnq5ga8DA=
Message-ID: <66bf47fc-643e-4e6b-ab6d-492024fdd2e7@tnxip.de>
Date: Mon, 17 Mar 2025 22:48:25 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Subject: Re: errors compiling bcachefs-tools v1.20.0 on debian 12
To: John Stoffel <john@stoffel.org>, linux-bcachefs@vger.kernel.org
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
 <26584.35900.850011.320586@quad.stoffel.home>
 <26584.36927.6100.282713@quad.stoffel.home>
Content-Language: en-US, de-DE
From: =?UTF-8?Q?Malte_Schr=C3=B6der?= <malte.schroeder@tnxip.de>
In-Reply-To: <26584.36927.6100.282713@quad.stoffel.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 17/03/2025 22:12, John Stoffel wrote:
> Hi guys,
> I'm trying to upgrade the bcachefs tools since I tend to use newer
> kernels on my Debian 12 system.  The debian packages bcachefs-tools
> are ancient.  
>
> So I cloned the repo, installed the pre-reqs and I'm trying to compile
> it, but I get the following:
>
>
> quad:/bcachefs/bcachefs1/bcachefs-tools$ make
>     [CC]     c_src/bcachefs.o
> In file included from ./libbcachefs/bcachefs.h:202,
>                  from c_src/tools-util.h:21,
>                  from c_src/cmds.h:10,
>                  from c_src/bcachefs.c:26:
> include/linux/srcu.h:10:41: error: return type is an incomplete type
>    10 | static inline struct urcu_gp_poll_state get_state_synchronize_rcu()
>       |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/srcu.h: In function ‘get_state_synchronize_rcu’:
> include/linux/srcu.h:12:16: warning: implicit declaration of function ‘start_poll_synchronize_rcu’ ]
>    12 |         return start_poll_synchronize_rcu();
>       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/srcu.h:12:16: warning: ‘return’ with a value, in function returning void [-Wreturn-ty]
>    12 |         return start_poll_synchronize_rcu();
>       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/srcu.h:10:41: note: declared here
>    10 | static inline struct urcu_gp_poll_state get_state_synchronize_rcu()
>       |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/srcu.h: At top level:
> include/linux/srcu.h:25:99: error: parameter 2 (‘cookie’) has incomplete type
>    25 | bool poll_state_synchronize_srcu(struct srcu_struct *ssp, struct urcu_gp_poll_state cookie)
>       |                                                           ~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
>
> include/linux/srcu.h: In function ‘poll_state_synchronize_srcu’:
> include/linux/srcu.h:27:16: warning: implicit declaration of function ‘poll_state_synchronize_rcu’;]
>    27 |         return poll_state_synchronize_rcu(cookie);
>       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                poll_state_synchronize_srcu
> include/linux/srcu.h: At top level:
> include/linux/srcu.h:30:41: error: return type is an incomplete type
>    30 | static inline struct urcu_gp_poll_state start_poll_synchronize_srcu(struct srcu_struct *ssp)
>       |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/srcu.h: In function ‘start_poll_synchronize_srcu’:
> include/linux/srcu.h:32:16: warning: ‘return’ with a value, in function returning void [-Wreturn-ty]
>    32 |         return start_poll_synchronize_rcu();
>       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/srcu.h:30:41: note: declared here
>    30 | static inline struct urcu_gp_poll_state start_poll_synchronize_srcu(struct srcu_struct *ssp)
>       |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/srcu.h: At top level:
> include/linux/srcu.h:35:41: error: return type is an incomplete type
>    35 | static inline struct urcu_gp_poll_state get_state_synchronize_srcu(struct srcu_struct *ssp)
>       |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~
> make: *** [Makefile:171: c_src/bcachefs.o] Error 1
> quad:/bcachefs/bcachefs1/bcachefs-tools$ git branch
>   master  * v1.20.0
>
Libs in Debian 12/Bookworm are too old for bcachefs-tools. I think
someone pulled it of by forcing some libs from Trixie, but that caused
other things to break.


