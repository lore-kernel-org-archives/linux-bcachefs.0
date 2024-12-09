Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2541F5F6
	for <linux-bcachefs@vger.kernel.org>; Mon,  9 Dec 2024 18:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767945; cv=none; b=ix9j3+YjVtghW/G7G9/r7wY550QZA56nf4Bx3DBmwLdB77HAgHfuzBzzzgcMPLLHtvJy5lc1KRqY+5xZawZXENAkbLwJS+P3NHEWA5SGLca5TGszzImnl4mhgoxkSfKQJwbmXcB82wbuzLZEoCinTcW8bB4ij685E1rNipZaaVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767945; c=relaxed/simple;
	bh=yoUrgK4WIHlzQWl3kA0Av2Vsc2BP10Kej3LtqCJ91lc=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=dHVyqUVUNtfHtkWZlkiV+1zjCqsTmWnYxgkMPtw0ttrur3zWupGQ/RHMiYF5Ml55KK+dSvqmmezK4Pe6Pe7v8IcKm1j0G9ybQhKBobEkZn3jzdS8KxG2Noxdq28BbsE3sekzoO3ccucZzIhEulhRmFibg4/xF0YogxiwP/ORqkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=4QEJqCJw; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="4QEJqCJw"
DKIM-Signature: a=rsa-sha256; bh=yoUrgK4WIHlzQWl3kA0Av2Vsc2BP10Kej3LtqCJ91lc=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1733767003; v=1; x=1734199003;
 b=4QEJqCJwhZ8KpZ+qaEdK+4E0pNmIxJLjAh97k8loHJriKwJeb5xcn3mDzSGCoYXm/si182E8
 56yWaFjp3UKxB9AIdnhK2jE5cdogiKGZuRJMZA2hUstLSbCe+KX7WtHqNG5yTIJVB/IVakxfjJ3
 3SXTrjKo1rF11F7aUF3FkRvKtkqcEufy59XbYB5DOM4Hm73ySNNwSCuELNP2Gycfl+k9AJzYiOw
 fI3RxFMXX8swnbREiiUWSaN6xvQAyWcWb318wiwXewLL+JB+dkL+N5DqWm6neq8RVkMyRVKdmNK
 NGm593uu3S8keBlZl0FLUOmafAg4B1VL4hD15CMXIE0FA==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id a39b5a3b; Tue, 10 Dec 2024
 01:56:43 +0800
Message-ID: <072d6776-5dea-4e70-af16-1cffb2e7f16b@archlinuxcn.org>
Date: Tue, 10 Dec 2024 01:56:39 +0800
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
References: <20241109105740.105652-2-integral@archlinuxcn.org>
Subject: Re: [PATCH] bcachefs-tools: make targets of subvolume create/delete
 required
Content-Language: en-US
From: Integral <integral@archlinuxcn.org>
In-Reply-To: <20241109105740.105652-2-integral@archlinuxcn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, Kent

Give you a gentle ping :)

