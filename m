Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0A55576B
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Jan 2024 18:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 8F87286C8A2;
	Thu, 11 Jan 2024 19:23:45 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: AP <lkml@inml.grue.cc>, linux-bcachefs@vger.kernel.org
Subject:
 Re: Error while unlocking encrypted BCacheFS: Required key not available
Date: Thu, 11 Jan 2024 19:23:45 +0100
Message-ID: <1876779.tdWV9SEqCh@lichtvoll.de>
In-Reply-To: <vm333u3hnogd2fz4zk6g4rhkj7rwk27tv2iacacsyjctxkcpvo@bihvvnluk3em>
References:
 <2312305.ElGaqSPkdT@lichtvoll.de> <12360099.O9o76ZdvQC@lichtvoll.de>
 <vm333u3hnogd2fz4zk6g4rhkj7rwk27tv2iacacsyjctxkcpvo@bihvvnluk3em>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Kent Overstreet - 11.01.24, 17:35:10 CET:
> I just made a couple suggestions. I'm sorry if they weren't exactly what
> you were looking for?
> 
> If you or someone else wants to help out by writing some code, I just
> laid out what needs to happen next - but I'm not your free helpdesk
> here, and you're expecting an imediate fix that's not how this works :)

That is a misunderstanding. I am not expecting an immediate fix or a fix at 
all. I did not write I do either. So please do not read something into 
what I wrote that simply is not there.

My programming experience in C is more than 20 years old, certainly not 
kernel related and not even on the Linux platform and I thought there 
might be something I as an user might try to at least pin-point the cause 
of this issue a bit more. Apparently there is not and that is okay with 
me.

Nothing of what I do with BCacheFS has immediate urgency at the moment.

-- 
Martin


