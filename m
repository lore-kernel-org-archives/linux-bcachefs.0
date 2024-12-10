Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6418168BE
	for <linux-bcachefs@vger.kernel.org>; Tue, 10 Dec 2024 05:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807307; cv=none; b=hwkO4vxhrO4/LY7XaT9h0iaVla1FPUG5+or8aVREW6CN8FI8Es1/s9K9gJkFI8LXWq4Zsc1HXqkF99p8MLd4xMM8z4DC204ddWGkwO/UQs8pIkweN1WirZ2Eu5k6odKNZn9EBf1R3VB8Tx2OsHBZ2Rr5ZMrqFpXRJoWMKyU6VfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807307; c=relaxed/simple;
	bh=hr+W7ZjYzpVSOMG9+vqWBqZV0gDO+J0HoyhBtMCePsk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iLSR6oIlk+ecqtoA8IlXULtUPe9nVpGR5dRT/kOHM6XgzWLi1nMrFmoGJWhytp7fiaXIWdhuXEebxMSNqSwCV6WZVkFs3EMvmOU3ZzQRRxC8R8GtO+5QdvzYEiQM9SizwFL9pbEYDvD/OG7J5WuRCzyhN2ny+JKakeEHsHnboog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=vIkJU5V/; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="vIkJU5V/"
DKIM-Signature: a=rsa-sha256; bh=hr+W7ZjYzpVSOMG9+vqWBqZV0gDO+J0HoyhBtMCePsk=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1733807283; v=1; x=1734239283;
 b=vIkJU5V/da0aWRmAd0CKE7HCUvDOrMv+cS+rxEn+kVrsTdCzQLjkoPZ2T9bk9l4UI/wyrI08
 xm0P8ro9rxuhUDxvbeFiBGBVsBjqeClXd+0nrKgVd5TP1pQUzchlwBFDVns2+rT+Nd+QT9ayy2E
 sOS2xod2aV6wFtn+JylFrKT86A2Lz50r03fRsaJa1KhnAEklopQKCigj3EByDrfPnvtI6Ytf1Yt
 oV3ohfhKtXhC1G3AwREI6TOh9fWVAimPQqp8BQ5Y4ZqRKzDY1Sfpf4nPkZXSLfBtsihtbw/3g4t
 DQWAZoEOFU5M5toWsXMQqGlbEGMigJSbkVcF69Q92XItw==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 5e6eed52; Tue, 10 Dec 2024
 13:08:03 +0800
Message-ID: <8cd43424-fab5-4f0b-90b7-d077dbae14b6@archlinuxcn.org>
Date: Tue, 10 Dec 2024 13:07:59 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: use strscpy & strscpy_pad to make string
 copying simpler & safer
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: kent.overstreet@gmail.com, lihongbo22@huawei.com, mmpgouride@gmail.com,
 linux-bcachefs@vger.kernel.org
References: <20241110064138.79527-1-integral@archlinuxcn.org>
 <okjlnanwuectw4fem6o3x7mheur7ob6nvkxm26rvhw7xxawx5v@n6qix4k2w5kp>
Content-Language: en-US
From: Integral <integral@archlinuxcn.org>
In-Reply-To: <okjlnanwuectw4fem6o3x7mheur7ob6nvkxm26rvhw7xxawx5v@n6qix4k2w5kp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I apologize for my repeated patch sending :(


However, you have just said

> I already told you this didn't need to be done; please stop.


Actually, this is the first time you have told me to stop doing this.

