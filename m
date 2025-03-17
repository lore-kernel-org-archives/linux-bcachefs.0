Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587C01F5839
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 20:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742245110; cv=none; b=bFq0zHx/xCww/UXAHi8Kb9DafC7p3Y1PYS08a9F3kBIzD4iwPu/qzoS0yXpBsRp+lwikP64DPiYT3IXU/pFZ9sRe/PofKY96TSmnpkIXDo+BfGUF5PFoJhSZzLDNYQzwTB56BLDsF8P2itwPYA94T5pgmggWm84AP6DCyaa3wdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742245110; c=relaxed/simple;
	bh=StH3TJNLjNzx6INJGImsE6EUKLmKr8g0OFiz0FbKvn0=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=NicrWqCkPObtep00XnBj/WpSbi0qtUrcicCpQAP6MCQNr8FnkcHCTUCtLoTevR9s8OQkKEs1ImFi6HvOXvLw8F4OoJL4iyINrhDQPyZliZ5cMBatRvOpRkk3GFfd7y3E72ElQjCDfyGp4d8XpiioxiwPHSGf2/XgpfPGqjAXJbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 45B361E6AF;
	Mon, 17 Mar 2025 16:58:27 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id E9968A0E78; Mon, 17 Mar 2025 16:58:26 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26584.36082.936426.143774@quad.stoffel.home>
Date: Mon, 17 Mar 2025 16:58:26 -0400
From: "John Stoffel" <john@stoffel.org>
To: Alan Huang <mmpgouride@gmail.com>
Cc: kent.overstreet@linux.dev,
    linux-bcachefs@vger.kernel.org
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: [PATCH] bcachefs: Increase blacklist range
In-Reply-To: <20250315073942.1909895-1-mmpgouride@gmail.com>
References: <20250315073942.1909895-1-mmpgouride@gmail.com>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Alan" == Alan Huang <mmpgouride@gmail.com> writes:

> Now there are 16 journal buffers, 8 is too small to be enough.
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
>  fs/bcachefs/recovery.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> index 71c786cdb192..a6e26733854d 100644
> --- a/fs/bcachefs/recovery.c
> +++ b/fs/bcachefs/recovery.c
> @@ -899,7 +899,7 @@ int bch2_fs_recovery(struct bch_fs *c)
>  	 * journal sequence numbers:
>  	 */
>  	if (!c->sb.clean)
> -		journal_seq += 8;
> +		journal_seq += JOURNAL_BUF_NR * 4;
 
Instead of magic numbers, could you put in a define with an
explanation of how you arrived at this number?  Just to document the
assumptions better?

John
