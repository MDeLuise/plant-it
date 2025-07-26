// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get enterValue => 'Por favor, insira um valor';

  @override
  String get enterValidURL => 'Por favor, insira uma URL válida';

  @override
  String get go => 'Continuar';

  @override
  String get noBackend => 'Não foi possível conectar ao servidor';

  @override
  String get ok => 'Ok';

  @override
  String get serverURL => 'URL do servidor';

  @override
  String get username => 'Nome de Usuário';

  @override
  String get password => 'Senha';

  @override
  String get login => 'Login';

  @override
  String get badCredentials => 'Credenciais inválidas';

  @override
  String get loginMessage => 'Bem-vindo de volta a';

  @override
  String get signupMessage => 'Bem-vindo a';

  @override
  String get appName => 'Plant-it';

  @override
  String get forgotPassword => 'Esqueceu sua senha?';

  @override
  String get areYouNew => 'Novo por aqui?';

  @override
  String get createAccount => 'Criar uma conta';

  @override
  String get email => 'E-mail';

  @override
  String get usernameSize =>
      'Seu nome de usuário precisa ter entre 3 e 20 caracteres';

  @override
  String get passwordSize => 'Sua senha precisa ter entre 6 e 20 caracteres';

  @override
  String get enterValidEmail =>
      'Por favor, insira um endereço de e-mail válido';

  @override
  String get alreadyRegistered => 'Já possui cadastro?';

  @override
  String get signup => 'Cadastro';

  @override
  String get generalError => 'Erro ao realizar a operação';

  @override
  String get error => 'Erro';

  @override
  String get details => 'Detalhes';

  @override
  String get insertBackendURL =>
      'Olá Amigo! Vamos fazer a mágica acontecer, comece inserindo a URL do servidor';

  @override
  String get loginTagline => 'Explore, aprenda e cultive!';

  @override
  String get singupTagline => 'Vamos plantar juntos!';

  @override
  String get sentOTPCode =>
      'Por favor, insira o código enviado ao seu e-mail: ';

  @override
  String get verify => 'Verificar';

  @override
  String get resendCode => 'Re-enviar código';

  @override
  String get otpCode => 'Código OTP';

  @override
  String get splashLoading => 'Beep boop beep... Carregando dados do servidor!';

  @override
  String get welcomeBack => 'Bem-vindo de volta';

  @override
  String hello(String userName) {
    return 'Olá, $userName';
  }

  @override
  String get search => 'Buscar';

  @override
  String get today => 'hoje';

  @override
  String get yesterday => 'ontem';

  @override
  String nDaysAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dias',
      one: 'dia',
    );
    return '$countString $_temp0 atrás';
  }

  @override
  String nDaysInFuture(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dias',
      one: 'dia',
    );
    return '$countString $_temp0 no futuro (quê?)';
  }

  @override
  String nMonthsAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'meses',
      one: 'mês',
    );
    return '$countString $_temp0 atrás';
  }

  @override
  String nYearsAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'anos',
      one: 'ano',
    );
    return '$countString $_temp0 atrás';
  }

  @override
  String get events => 'Eventos';

  @override
  String get plants => 'Plantas';

  @override
  String get or => 'ou';

  @override
  String get filter => 'Filtro';

  @override
  String get seeding => 'Semeadura';

  @override
  String get watering => 'Rega';

  @override
  String get fertilizing => 'Fertilização';

  @override
  String get biostimulating => 'Bioestimulação';

  @override
  String get misting => 'Nebulização';

  @override
  String get transplanting => 'Transplante';

  @override
  String get water_changing => 'Troca de água';

  @override
  String get observation => 'Observando';

  @override
  String get treatment => 'Tratamento';

  @override
  String get propagating => 'Propagação';

  @override
  String get pruning => 'Poda';

  @override
  String get repotting => 'Reenvasamento';

  @override
  String get recents => 'Recentes';

  @override
  String get addNewEvent => 'Adicionar novo evento';

  @override
  String get selectDate => 'Selecionar data';

  @override
  String get selectEvents => 'Selecionar eventos';

  @override
  String get selectPlants => 'Selecionar plantas';

  @override
  String nEventsCreated(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'eventos',
      one: 'evento',
    );
    return 'Criado $countString novo $_temp0';
  }

  @override
  String get addNote => 'Adicionar nota';

  @override
  String get enterNote => 'Inserir nota';

  @override
  String get selectAtLeastOnePlant => 'Selecione ao menos uma planta';

  @override
  String get selectAtLeastOneEvent => 'Selecione ao menos um evento';

  @override
  String get eventSuccessfullyUpdated => 'Evento atualizado com sucesso';

  @override
  String get editEvent => 'Editar evento';

  @override
  String get eventSuccessfullyDeleted => 'Evento deletado com sucesso';

  @override
  String get noInfoAvailable => 'Nenhuma informação disponível';

  @override
  String get species => 'Espécies';

  @override
  String get plant => 'Planta';

  @override
  String get scientificClassification => 'Classificação científica';

  @override
  String get family => 'Familia';

  @override
  String get genus => 'Gene';

  @override
  String get synonyms => 'Sinônimos';

  @override
  String get care => 'Cuidado';

  @override
  String get light => 'Luz';

  @override
  String get humidity => 'Umidade';

  @override
  String get maxTemp => 'Temperatura máxima';

  @override
  String get minTemp => 'Temperatura mínima';

  @override
  String get minPh => 'Ph mínimo';

  @override
  String get maxPh => 'Ph máximo';

  @override
  String get info => 'Informações';

  @override
  String get addPhotos => 'Adicionar fotos';

  @override
  String get addEvents => 'Adicionar eventos';

  @override
  String get modifyPlant => 'Modificar planta';

  @override
  String get removePlant => 'Remover planta';

  @override
  String get useBirthday => 'Usar aniversário';

  @override
  String get birthday => 'Aniversário';

  @override
  String get avatar => 'Avatar';

  @override
  String get note => 'Nota';

  @override
  String get stats => 'Estatísticas';

  @override
  String get eventStats => 'Estatísticas de eventos';

  @override
  String get age => 'Idade';

  @override
  String get newBorn => 'Recém nascido';

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dias',
      one: 'dia',
    );
    return '$countString $_temp0';
  }

  @override
  String nMonths(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mêses',
      one: 'mês',
    );
    return '$countString $_temp0';
  }

  @override
  String nYears(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'anos',
      one: 'ano',
    );
    return '$countString $_temp0';
  }

  @override
  String nMonthsAndDays(num months, num days) {
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String monthsString = monthsNumberFormat.format(months);
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'meses',
      one: 'mês',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dias',
      one: 'dia',
    );
    return '$monthsString $_temp0, $daysString $_temp1';
  }

  @override
  String nYearsAndDays(num years, num days) {
    final intl.NumberFormat yearsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String yearsString = yearsNumberFormat.format(years);
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'anos',
      one: 'ano',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dias',
      one: 'dia',
    );
    return '$yearsString $_temp0, $daysString $_temp1';
  }

  @override
  String nYearsAndMonths(num years, num months) {
    final intl.NumberFormat yearsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String yearsString = yearsNumberFormat.format(years);
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String monthsString = monthsNumberFormat.format(months);

    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'anos',
      one: 'ano',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'meses',
      one: 'mês',
    );
    return '$yearsString $_temp0, $monthsString $_temp1';
  }

  @override
  String nYearsAndMonthsAndDays(num years, num months, num days) {
    final intl.NumberFormat yearsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String yearsString = yearsNumberFormat.format(years);
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String monthsString = monthsNumberFormat.format(months);
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'anos',
      one: 'ano',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'meses',
      one: 'mês',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dias',
      one: 'dia',
    );
    return '$yearsString $_temp0, $monthsString $_temp1, $daysString $_temp2';
  }

  @override
  String get name => 'Nome';

  @override
  String nOutOf(num value, num max) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String valueString = valueNumberFormat.format(value);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String maxString = maxNumberFormat.format(max);

    return '$valueString de $maxString';
  }

  @override
  String temp(num value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString °C';
  }

  @override
  String get numberOfPhotos => 'Numero de fotos';

  @override
  String get numberOfEvents => 'Numero de eventos';

  @override
  String get searchInYourPlants => 'Buscar nas suas plantas';

  @override
  String get searchNewGreenFriends => 'Buscar novos amigos verdes';

  @override
  String get custom => 'Customizado';

  @override
  String get addPlant => 'Adicionar Planta';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get pleaseConfirm => 'Por favor, confirme';

  @override
  String get areYouSureToRemoveEvent =>
      'Tem certeza que deseja remover este evento?';

  @override
  String get areYouSureToRemoveReminder =>
      'Tem certeza que deseja remover este lembrete?';

  @override
  String get areYouSureToRemoveSpecies =>
      'Tem certeza que deseja remover esta espécie?';

  @override
  String get areYouSureToRemovePlant =>
      'Tem certeza que deseja remover esta planta?';

  @override
  String get purchasedPrice => 'Preço de compra';

  @override
  String get seller => 'Vendedor';

  @override
  String get location => 'Localização';

  @override
  String get currency => 'Moeda';

  @override
  String get plantUpdatedSuccessfully => 'Planta atualizada com sucesso';

  @override
  String get plantCreatedSuccessfully => 'Planta criada com sucesso';

  @override
  String get insertPrice => 'Insira o preço';

  @override
  String get noBirthday => 'Sem aniversário';

  @override
  String get appVersion => 'Versão do aplicativo';

  @override
  String get serverVersion => 'Versão do servidor';

  @override
  String get documentation => 'Documentação';

  @override
  String get openSource => 'Código aberto';

  @override
  String get reportIssue => 'Reportar problema';

  @override
  String get logout => 'Sair';

  @override
  String get eventCount => 'Contador de eventos';

  @override
  String get plantCount => 'Contador de plantas';

  @override
  String get speciesCount => 'Contador de espécies';

  @override
  String get imageCount => 'Contador de imagens';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get account => 'Conta';

  @override
  String get changePassword => 'Mudar senha';

  @override
  String get more => 'Mais';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get currentPassword => 'Senha atual';

  @override
  String get updatePassword => 'Atualizar senha';

  @override
  String get updateProfile => 'Atualizar perfil';

  @override
  String get newPassword => 'Nova senha';

  @override
  String get removeEvent => 'Remover evento';

  @override
  String get appLog => 'Registros do aplicativo';

  @override
  String get passwordUpdated => 'Senha alterada com sucesso';

  @override
  String get userUpdated => 'Usuário alterado com sucesso';

  @override
  String get noChangesDetected => 'Nenhuma mudança detectada';

  @override
  String get plantDeletedSuccessfully => 'Planta deletada com sucesso';

  @override
  String get server => 'Servidor';

  @override
  String get notifications => 'Notificações';

  @override
  String get changeServer => 'Mudar servidor';

  @override
  String get serverUpdated => 'Servidor alterado com sucesso';

  @override
  String get changeNotifications => 'Mudar notificações';

  @override
  String get updateNotifications => 'Atualizar notificações';

  @override
  String get notificationUpdated => 'Notificação atualizada com sucesso';

  @override
  String get supportTheProject => 'Apoie o projeto';

  @override
  String get buyMeACoffee => 'Me page um café';

  @override
  String get gallery => 'Galeria';

  @override
  String photosOf(String name) {
    return 'Fotos de $name';
  }

  @override
  String nPhoto(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'novas fotos',
      one: 'nova foto',
    );
    return 'Enviar $countString $_temp0';
  }

  @override
  String get errorCreatingPlant => 'Erro ao criar planta';

  @override
  String get noImages => 'Nenhuma imagem';

  @override
  String get errorCreatingSpecies => 'Erro ao criar espécie';

  @override
  String get errorUpdatingSpecies => 'Erro ao atualizar espécie';

  @override
  String get speciesUpdatedSuccessfully => 'Espécies atualizadas com sucesso';

  @override
  String get addCustom => 'Adicionar Customizado';

  @override
  String get speciesCreatedSuccessfully => 'Espécies criadas com sucesso';

  @override
  String get uploadPhoto => 'Enviar foto';

  @override
  String get linkURL => 'Link URL';

  @override
  String get url => 'URL';

  @override
  String get submit => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get actions => 'Ações';

  @override
  String get areYouSureToRemovePhoto =>
      'Tem certeza que deseja remover essa foto?';

  @override
  String get photoSuccessfullyDeleted => 'Foto removida com sucesso';

  @override
  String get errorUpdatingPlant => 'Erro ao atualizar a planta';

  @override
  String get reminders => 'Lembretes';

  @override
  String get selectStartDate => 'Selecione uma data inicial';

  @override
  String get selectEndDate => 'Selecione uma data final';

  @override
  String get addNewReminder => 'Novo lembrete';

  @override
  String get noEndDate => 'Sem data final';

  @override
  String get frequency => 'Frequência';

  @override
  String get repeatAfter => 'Repetir após';

  @override
  String get addNew => 'Adicionar novo';

  @override
  String get reminderCreatedSuccessfully => 'Lembrete criado com sucesso';

  @override
  String get startAndEndDateOrderError =>
      'A data inicial deve ser antes da data final';

  @override
  String get reminderUpdatedSuccessfully => 'Lembrete atualizado com sucesso';

  @override
  String get reminderDeletedSuccessfully => 'Lembrete deletado com sucesso';

  @override
  String get errorResettingPassword => 'Erro ao recuperar a senha';

  @override
  String get resetPassword => 'Recuperar senha';

  @override
  String get resetPasswordHeader =>
      'Insira o nome de usuário abaixo para enviar um pedido de recuperação de senha';

  @override
  String get editReminder => 'Editar lembrete';

  @override
  String get ntfyServerUrl => 'URL do servidor Ntfy';

  @override
  String get ntfyServerTopic => 'Tópico do servidor Ntfy';

  @override
  String get ntfyServerUsername => 'Nome de usuário do servidor Ntfy';

  @override
  String get ntfyServerPassword => 'Senha do servidor Ntfy';

  @override
  String get ntfyServerToken => 'Token do servidor Ntfy';

  @override
  String get enterValidTopic => 'Por favor, insira um tópico válido';

  @override
  String get ntfySettings => 'Configurações do Ntfy';

  @override
  String get ntfySettingsUpdated =>
      'Configurações do Ntfy atualizadas com sucesso';

  @override
  String get modifySpecies => 'Modificar espécies';

  @override
  String get removeSpecies => 'Excluir espécies';

  @override
  String get speciesDeletedSuccessfully => 'Espécies excluídas com sucesso';

  @override
  String get success => 'Sucesso';

  @override
  String get warning => 'Aviso';

  @override
  String get ops => 'Ops!';

  @override
  String get changeLanguage => 'Alterar idioma';

  @override
  String get gotifyServerUrl => 'URL do servidor Gotify';

  @override
  String get gotifyServerToken => 'Token do servidor Gotify';

  @override
  String get gotifySettings => 'Configurações do Gotify';

  @override
  String get gotifySettingsUpdated =>
      'Configurações do Gotify atualizadas corretamente';

  @override
  String get activity => 'Atividade';

  @override
  String get fromDate => 'de';

  @override
  String frequencyEvery(num amount, String unit) {
    return 'a cada $amount $unit';
  }

  @override
  String day(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dias',
      one: 'dia',
    );
    return '$_temp0';
  }

  @override
  String week(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'semanas',
      one: 'semana',
    );
    return '$_temp0';
  }

  @override
  String month(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'meses',
      one: 'mês',
    );
    return '$_temp0';
  }

  @override
  String year(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'anos',
      one: 'ano',
    );
    return '$_temp0';
  }
}
