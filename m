Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81EA1E7C20
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Nov 2024 13:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731074342; cv=none; b=rTDcPnjXg3AP6pLPtR+sn0EIUi39X6slVQdepkcmFsB0NXnx2D94Bh5LBxDadKRW+VzY+No8xxOgEhBRuC7O3PVriwVrxU4WNJior/RGKUzCb5Tcx23D1f1gwE1EDOD2Mo6UL0pW5wQaj3UzYmU5DpLpGk0g78wpLMLJEMwg0jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731074342; c=relaxed/simple;
	bh=DtPp+v9SXmz8ixlwEjA/8CDAJ6igadjuA/UBaDak4nY=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=TvHXyR98QicbB19Cq5UCt01JKmQl8V99Qr9ePdAeqLNHBHnzThslXWFKNnRpPS/Q+/+eWkhlp+WtDBTUwTiCxthRp6PLEzFmZJKHdsCyPLeL/OQPmTQHrGQSUlm+G+ZLNzKEc4M9xRwbHmaHNEdWYOGCgkPBeom//+hzApCTcC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=QblLFD8M; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="QblLFD8M"
DKIM-Signature: a=rsa-sha256; bh=DtPp+v9SXmz8ixlwEjA/8CDAJ6igadjuA/UBaDak4nY=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1731074310; v=1; x=1731506310;
 b=QblLFD8M1zwTBiuuHTZljMFpwCzvJHK65B4zEPlOR9NN35PgESJwd/Jba7fv29yJgMLWjvz1
 jFeKuDlkDGqOZBwiOsVAtY9pgdHe6+WprPN+T0YIXQB3euiF8nVurUi6GIpvVEolXMlSZe1rX46
 340DY4zjAFFUdbf5/09+IIpC9/NgNpRKon6VOU6W+ileONsjGQU5QRZlmYDsCvs/mutbOM1X5TD
 sRnZ+8+l23Vvj/UHver3Wtfz6159DR+uODH+2wrh8GwOvxBRLVAsfYdXf9TrvMEEcW+Cm9G2JJV
 l9bl33w/g3k2Ufiujve8zhGGssKx7BG6TIg0GYKIzp4KQ==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 40c91aad; Fri, 08 Nov 2024
 21:58:30 +0800
Message-ID: <de5d523f-5352-4c4d-8c21-36a965e00215@archlinuxcn.org>
Date: Fri, 8 Nov 2024 21:58:25 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: integral@archlinuxcn.org
Cc: kent.overstreet@gmail.com, kent.overstreet@linux.dev,
 lihongbo22@huawei.com, linux-bcachefs@vger.kernel.org, mmpgouride@gmail.com
References: <20241027142127.110704-1-integral@archlinuxcn.org>
Subject: Re: [PATCH] bcachefs-tools: replace multiple if with match to improve
 readability
Content-Language: en-US
From: Integral <integral@archlinuxcn.org>
In-Reply-To: <20241027142127.110704-1-integral@archlinuxcn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, Kent

Give you a friendly ping :)

