Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D005517C64
	for <linux-bcachefs@vger.kernel.org>; Thu, 30 May 2024 01:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717033767; cv=none; b=kMj3iZUx4pQdKvjP1K6JN1Z3RGfPvD1y2tF4Nuk/OcNgDGAD9x24UBR7UQJQ/tTpG5X5KiZOuR5oEsW/J+pturr3zBUhJUzHz741jhZ7mVYhfYm2UA3AEsxe46eF0CEKakMeMwqwjHEwDSonUf0l/ActAwsU9sJHMJrOA3L1ioo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717033767; c=relaxed/simple;
	bh=bdyqCnBSvB4bX+JjKbSiu2utN8uyaBs0rPiYUFcPcCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSclnMp7ZRBeXkUHFC3mb4iFpJo11KCtrW4VAOCJ3z9altwnvrONsA0J2c6MOGY6kP6LeRhC3+fD15qSPwCwadH4JmrayV5NGrJIaF5nCVIKq+SggF3LWZHoANUt4UUneTr2g7KXP47gxUTLyo4U+zMXw+8UrmASUTkXXQcnoIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I3n8UH09; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I3n8UH09"
X-Envelope-To: tahbertschinger@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717033760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bdyqCnBSvB4bX+JjKbSiu2utN8uyaBs0rPiYUFcPcCY=;
	b=I3n8UH09N60x5mrA+AjS8L3lCSqgcPHA7y+y5oI8yP5fV1y3SpyCQFttazIeAUbVTiDerG
	LZiPWrujIF5MHEIxBely9vkANX9CbiTyEVQKTb75ElgoVn0WHeLFP0Cy7rXBSgmkR9y4Aq
	Qr8Is0r4iuz/UZB5ffmv5bNKs3AWxng=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: lkp@intel.com
Date: Wed, 29 May 2024 21:49:16 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com, 
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] bcachefs: fix uninitialized variable in bch2_remount()
Message-ID: <zu6b2gsae3sm7uv3zyzx4d5qt22sgjqivp25hj4dxkeim7muj6@apwpu6ubp3sl>
References: <20240530013814.849633-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530013814.849633-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 29, 2024 at 07:38:14PM -0600, Thomas Bertschinger wrote:
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202405291826.785pVN5c-lkp@intel.com/
> Fixes: d6a5e45c75bb ("bcachefs: use new mount API")
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

folded in
