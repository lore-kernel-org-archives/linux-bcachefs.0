Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5650198842
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 11:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732707243; cv=none; b=GoZHx8OzU17SwkA+Nw9tUYepHQM0+/gl3tmr674N445BBgFDYsVT/iyEepv6XHjRwvi54Z4qq98G5IsuLhER7YpcplyoGOhKyycKBUchk94UURh9/0OOTQN5nKTA+Si/Z9k8vPi93FN0+V/CGFktLBX/LKzfIg+NJup9a+3TMd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732707243; c=relaxed/simple;
	bh=yoUrgK4WIHlzQWl3kA0Av2Vsc2BP10Kej3LtqCJ91lc=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=WoYtUdNLTAFs9g7NOVG+dX9mFgLzObKZ38qGCacmX77DT5t1iaphGaM121EDwEAtvV5pSc74CSHkxPUpgrmp3pnSZesNv8qEKar8t1yMyY/kWnSE48wv+HbodTeMw+DcdwcwFUZLxZJ3hyIZU8BfrY6uKlnZ3++ApvJHVlw/8I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=tX4ImZej; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="tX4ImZej"
DKIM-Signature: a=rsa-sha256; bh=yoUrgK4WIHlzQWl3kA0Av2Vsc2BP10Kej3LtqCJ91lc=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1732706284; v=1; x=1733138284;
 b=tX4ImZejSZbwyozDcRUV9sf8dd8vekL2iy+0iQsgR694rmMm2ozSBqNw0Y3bmL37Ydp/4ajo
 u3iZiQfcPAxFNJl94YGiN1PIBEduGOo2Y19/mZghYsKOxdRA/Is9pRQtABo4PD7aI9sJGRdrFYa
 80iXtd+xQa08jzT5QNReLqsOJMrjE4qU85Q5mfUpHeZRSf7HKAF8p6gDw8BOktzQimJYvBOSqdN
 LTaBEEx1B4eFOwa8q5SAnFr/AHQuND4qBPspNG5kYCYeLDnYzovPT44xAmwydB0pd5RMxz57iVA
 +EhE1c/vWoGB+kYAVoHSop729J19+hzKLygBbVn2SlfDQ==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id d88d6b95; Wed, 27 Nov 2024
 19:18:04 +0800
Message-ID: <1ac82f06-bb7f-4f1c-bfe4-f61158930668@archlinuxcn.org>
Date: Wed, 27 Nov 2024 19:18:00 +0800
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

Give you a gentle ping :)

