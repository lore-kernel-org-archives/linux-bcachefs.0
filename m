Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F90D6BFC7
	for <linux-bcachefs@vger.kernel.org>; Sat, 24 Aug 2024 17:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724522365; cv=none; b=lVva+UFdVVe6JS9MYpNPADKW2ffgHHkkIoGTUljxG8uSWNrfs3qQl4mSJR2EGtHnQuNmc7GBLyIa+f10SK63UJ4/zBeku9WLGQWdi2+PNveSmdEKjDGBzp3196E5USS0HvZN1KrAWj+VkGC0u7UE0OpiTBQkSw0BCPk19aKHp6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724522365; c=relaxed/simple;
	bh=EfxGkLvlnQVophhgVpZIEwOn6vYeBOCx1Ac+KXmpIsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=btKbknDQvC1ZpW8+5zyPdgDBO96tKXlGJvWHzbtgjuKpm/PWnK6RtkQUP7BMoxjdzRWj2fyLUML2R35i+EXEdejvu4sjsMKNs72jSN44fevctF/czZmE0WxiohQv0q2ZTAeHB57Qy9WycBt6xukTKmJz7p4aAmn0alYZPMhpetc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iOilqeaz; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iOilqeaz"
Date: Sat, 24 Aug 2024 13:59:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724522361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EYobkU7jwthVopRG5e6pdzVo4QhQPLczqWczkGXdKLY=;
	b=iOilqeazH09s7oLyjIcETAmrMU1OcrK5zdr10GW2DQcoW3WWHcoYZFD0sZYQqn3yya15vz
	AbxYeyIqyCEZ3QJwWXfqHRu1lAb4SKbqZsnZtQ0WFV3bpDSzGhSqdRvCRDRg7PX+uQwUQs
	GhgswRb2Ud6WbfGlZ4bJ28bHkivpdp4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: kees@kernel.org, gustavoars@kernel.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Annotate struct bch_xattr with __counted_by()
Message-ID: <ncavolexjlz5j2uaiklynoeiuoqatwrqy3elop5f6dg3444m3e@pegucwwr57bc>
References: <20240824135740.1971-2-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240824135740.1971-2-thorsten.blum@toblux.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Aug 24, 2024 at 03:57:41PM GMT, Thorsten Blum wrote:
> Add the __counted_by compiler attribute to the flexible array member
> x_name to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>

Applied
