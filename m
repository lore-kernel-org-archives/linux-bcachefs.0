Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4813D2AE7F
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 14:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752848520; cv=none; b=clbqrdy/NvaQIpVBmYmlikJ51d5AenXTM6KL4i/E8v4JN0zbrROeYXW2TmzQspXUaPPD/fqRqbvpR/vDAoQUC4gr6o+zD2uywHcFvUGeHfiXmlFYKC6DI9rCtVjDTBypUKJR8b6AnzkiuSsQ53195KGdZiAOdzJZH0qOEbQ6M5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752848520; c=relaxed/simple;
	bh=Y3TnufykPdRlCMOrR3XUxHR6EKTb9GqVwwzX/BB9XRQ=;
	h=Date:From:To:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=RajeX5G01clqULUgj6RC7wweVDwCQhRvrOqKdTazkfMJqc1TDQbCm0hp+ldCJSjw3T/enIZ8IbTLNZLsPjHex3gfL1gpgkp0Uu1K+9++5pCCDb549MFTsqKUfvxduP1tpbunMoVeL2SJyO0cGTNyPlHsgJIKUwBK0vD2qnWfFwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 34A0F1003C501D; Fri, 18 Jul 2025 16:21:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 32D281100AF010
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 16:21:53 +0200 (CEST)
Date: Fri, 18 Jul 2025 16:21:53 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: linux-bcachefs@vger.kernel.org
Subject: Re: Reported filesystem size (fs usage, df) discrepancies
In-Reply-To: <558o6n97-6sn1-20ns-5n62-79s106p86747@vanv.qr>
Message-ID: <sq83p32s-p1p9-r1r1-63q5-n45prp0s614s@vanv.qr>
References: <558o6n97-6sn1-20ns-5n62-79s106p86747@vanv.qr>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Thursday 2025-07-17 17:40, Jan Engelhardt wrote:
># bcachefs fs usage /v | head -n2
>Filesystem: (uuid)
>Size:                  5373893950976 [5004 GiB]
>
>How did we reportedly lose 393 GiB / 7.8%?

Once I specifically asked $internet for "8%", information rather
copiously started appearing.

 https://lobste.rs/c/ifvz2n
 https://bcachefs.org/bcachefs-principles-of-operation.pdf pg. 3

pointing to garbage collection. Now it kinda all comes together,
including these mkfs lines.

>  gc_reserve_percent:                      8
>  gc_reserve_bytes:                        0 B
